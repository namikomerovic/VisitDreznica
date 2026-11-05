using System.Data;
using Microsoft.EntityFrameworkCore;
using VisitDreznica.Model.Enums;
using VisitDreznica.Model.Exceptions;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Services.Database;
using VisitDreznica.Services.Database.Entities;
using VisitDreznica.Services.Security;

namespace VisitDreznica.Services.Reservations;

public class EquipmentReservationService(VisitDreznicaDbContext dbContext, ICurrentUser currentUser)
    : IEquipmentReservationService
{
    public const int MaxRentalHours = 12;

    public async Task<EquipmentReservationQuoteResponse> QuoteAsync(EquipmentReservationRequest request)
    {
        var (_, quote, _, _) = await ValidateAndCalculateAsync(request);
        return quote;
    }

    public async Task<ReservationResponse> CreateAsync(EquipmentReservationRequest request)
    {
        await using var transaction = await dbContext.Database.BeginTransactionAsync(IsolationLevel.Serializable);

        var (equipment, quote, startTime, endTime) = await ValidateAndCalculateAsync(request);

        if (!quote.IsAvailable)
        {
            throw new BusinessException(
                $"U odabranom periodu slobodno je samo {quote.AvailableQuantity} komada opreme '{equipment.Name}'.");
        }

        var now = DateTime.UtcNow;

        var reservation = new EquipmentReservation
        {
            EquipmentId = equipment.Id,
            Quantity = request.Quantity,
            StartTime = startTime,
            EndTime = endTime,
            TotalPrice = quote.TotalPrice,
            Note = string.IsNullOrWhiteSpace(request.Note) ? null : request.Note.Trim(),
            Status = ReservationStatus.Pending,
            UserId = currentUser.UserId,
            CreatedAt = now
        };

        ReservationHistory.Record(reservation, null, ReservationStatus.Pending, currentUser.UserId, "Rezervacija kreirana.", now);

        dbContext.EquipmentReservations.Add(reservation);
        await dbContext.SaveChangesAsync();
        await transaction.CommitAsync();

        return await dbContext.GetResponseAsync(reservation.Id);
    }

    private async Task<(Equipment Equipment, EquipmentReservationQuoteResponse Quote, DateTime StartTime, DateTime EndTime)>
        ValidateAndCalculateAsync(EquipmentReservationRequest request)
    {
        var startTime = request.StartTime!.Value.ToUniversalTime();
        var endTime = request.EndTime!.Value.ToUniversalTime();
        var duration = endTime - startTime;

        if (startTime <= DateTime.UtcNow)
        {
            throw new BusinessException("Početak najma mora biti u budućnosti.");
        }

        if (duration <= TimeSpan.Zero)
        {
            throw new BusinessException("Kraj najma mora biti nakon početka.");
        }

        if (duration > TimeSpan.FromHours(MaxRentalHours))
        {
            throw new BusinessException($"Najam može trajati najviše {MaxRentalHours} sati.");
        }

        var equipment = await dbContext.Equipment.AsNoTracking().FirstOrDefaultAsync(x => x.Id == request.EquipmentId && x.IsActive)
                        ?? throw new BusinessException("Odabrana oprema ne postoji ili trenutno nije dostupna.");

        var hours = (int)Math.Ceiling(duration.TotalHours);
        var unitPrice = Math.Min(
            equipment.FirstHourPrice + (hours - 1) * equipment.AdditionalHourPrice,
            equipment.FullDayPrice);

        var overlapping = await dbContext.EquipmentReservations
            .AsNoTracking()
            .Where(x => x.EquipmentId == equipment.Id &&
                        ReservationRules.ActiveStatuses.Contains(x.Status) &&
                        x.StartTime < endTime &&
                        startTime < x.EndTime)
            .Select(x => new UsagePeriod(x.StartTime, x.EndTime, x.Quantity))
            .ToListAsync();

        var availableQuantity = Math.Max(equipment.TotalQuantity - MaxConcurrentUsage(overlapping, startTime, endTime), 0);

        var quote = new EquipmentReservationQuoteResponse
        {
            Hours = hours,
            UnitPrice = unitPrice,
            Quantity = request.Quantity,
            TotalPrice = unitPrice * request.Quantity,
            AvailableQuantity = availableQuantity,
            IsAvailable = request.Quantity <= availableQuantity
        };

        return (equipment, quote, startTime, endTime);
    }

    private static int MaxConcurrentUsage(List<UsagePeriod> periods, DateTime from, DateTime to)
    {
        var checkpoints = periods
            .Select(x => x.Start)
            .Where(time => time > from && time < to)
            .Append(from);

        return checkpoints
            .Select(time => periods.Where(x => x.Start <= time && time < x.End).Sum(x => x.Quantity))
            .DefaultIfEmpty(0)
            .Max();
    }

    private sealed record UsagePeriod(DateTime Start, DateTime End, int Quantity);
}
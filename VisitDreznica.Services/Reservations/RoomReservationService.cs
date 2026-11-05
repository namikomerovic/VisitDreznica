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

public class RoomReservationService(
    VisitDreznicaDbContext dbContext,
    ICurrentUser currentUser,
    ReservationSettings settings) : IRoomReservationService
{
    public const int MaxNights = 30;
    private static readonly TimeOnly CheckInTimeUtc = new(12, 0);
    private static readonly TimeOnly CheckOutTimeUtc = new(8, 0);

    private static readonly ReservationStatus[] ActiveStatuses = [ReservationStatus.Pending, ReservationStatus.Confirmed];

    public async Task<RoomReservationQuoteResponse> QuoteAsync(RoomReservationRequest request)
    {
        var (_, quote) = await ValidateAndCalculateAsync(request);
        return quote;
    }

    public async Task<ReservationResponse> CreateAsync(RoomReservationRequest request)
    {
        await using var transaction = await dbContext.Database.BeginTransactionAsync(IsolationLevel.Serializable);

        var (room, quote) = await ValidateAndCalculateAsync(request);
        var now = DateTime.UtcNow;

        var reservation = new RoomReservation
        {
            RoomId = room.Id,
            GuestCount = request.GuestCount,
            StartTime = ToCheckInTime(request.CheckIn!.Value),
            EndTime = ToCheckOutTime(request.CheckOut!.Value),
            TotalPrice = quote.TotalPrice,
            Note = string.IsNullOrWhiteSpace(request.Note) ? null : request.Note.Trim(),
            Status = ReservationStatus.Pending,
            UserId = currentUser.UserId,
            CreatedAt = now
        };

        ReservationHistory.Record(reservation, null, ReservationStatus.Pending, currentUser.UserId, "Rezervacija kreirana.", now);

        dbContext.RoomReservations.Add(reservation);
        await dbContext.SaveChangesAsync();
        await transaction.CommitAsync();

        return await dbContext.Reservations
            .AsNoTracking()
            .Where(x => x.Id == reservation.Id)
            .Select(ReservationProjections.ToResponse)
            .FirstAsync();
    }

    public async Task<List<DateRangeResponse>> GetOccupiedPeriodsAsync(int roomId, DateOnly from, DateOnly to)
    {
        var fromTime = ToCheckInTime(from);
        var toTime = ToCheckOutTime(to);

        var periods = await dbContext.RoomReservations
            .AsNoTracking()
            .Where(x => x.RoomId == roomId &&
                        ActiveStatuses.Contains(x.Status) &&
                        x.StartTime < toTime &&
                        fromTime < x.EndTime)
            .OrderBy(x => x.StartTime)
            .Select(x => new { x.StartTime, x.EndTime })
            .ToListAsync();

        return periods
            .Select(x => new DateRangeResponse
            {
                From = DateOnly.FromDateTime(x.StartTime),
                To = DateOnly.FromDateTime(x.EndTime)
            })
            .ToList();
    }

    private async Task<(Room Room, RoomReservationQuoteResponse Quote)> ValidateAndCalculateAsync(RoomReservationRequest request)
    {
        var checkIn = request.CheckIn!.Value;
        var checkOut = request.CheckOut!.Value;
        var today = DateOnly.FromDateTime(DateTime.UtcNow);

        if (checkIn < today)
        {
            throw new BusinessException("Datum dolaska ne može biti u prošlosti.");
        }

        if (checkOut <= checkIn)
        {
            throw new BusinessException("Datum odlaska mora biti nakon datuma dolaska.");
        }

        var nights = checkOut.DayNumber - checkIn.DayNumber;

        if (nights > MaxNights)
        {
            throw new BusinessException($"Boravak može trajati najviše {MaxNights} noćenja.");
        }

        var room = await dbContext.Rooms.AsNoTracking().FirstOrDefaultAsync(x => x.Id == request.RoomId && x.IsActive)
                   ?? throw new BusinessException("Odabrana soba ne postoji ili trenutno nije dostupna.");

        if (request.GuestCount > room.Capacity)
        {
            throw new BusinessException($"Soba '{room.Name}' prima najviše {room.Capacity} osoba.");
        }

        var startTime = ToCheckInTime(checkIn);
        var endTime = ToCheckOutTime(checkOut);

        var isOccupied = await dbContext.RoomReservations.AnyAsync(x =>
            x.RoomId == room.Id &&
            ActiveStatuses.Contains(x.Status) &&
            x.StartTime < endTime &&
            startTime < x.EndTime);

        if (isOccupied)
        {
            throw new BusinessException("Soba je zauzeta u odabranom periodu. Odaberite druge datume.");
        }

        var accommodationPrice = nights * room.PricePerNight;
        var touristTax = nights * request.GuestCount * settings.TouristTaxPerPersonNight;

        var quote = new RoomReservationQuoteResponse
        {
            Nights = nights,
            PricePerNight = room.PricePerNight,
            AccommodationPrice = accommodationPrice,
            TouristTax = touristTax,
            TotalPrice = accommodationPrice + touristTax
        };

        return (room, quote);
    }

    private static DateTime ToCheckInTime(DateOnly date) => date.ToDateTime(CheckInTimeUtc, DateTimeKind.Utc);

    private static DateTime ToCheckOutTime(DateOnly date) => date.ToDateTime(CheckOutTimeUtc, DateTimeKind.Utc);
}
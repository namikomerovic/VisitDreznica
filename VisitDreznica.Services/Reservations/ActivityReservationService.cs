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

public class ActivityReservationService(VisitDreznicaDbContext dbContext, ICurrentUser currentUser)
    : IActivityReservationService
{
    public async Task<ReservationResponse> CreateAsync(ActivityReservationRequest request)
    {
        await using var transaction = await dbContext.Database.BeginTransactionAsync(IsolationLevel.Serializable);

        var slot = await dbContext.ActivitySlots
                       .AsNoTracking()
                       .Where(x => x.Id == request.ActivitySlotId)
                       .Select(x => new
                       {
                           x.Id,
                           x.StartTime,
                           x.EndTime,
                           x.Capacity,
                           ActivityName = x.Activity.Name,
                           x.Activity.IsActive,
                           x.Activity.PricePerPerson
                       })
                       .FirstOrDefaultAsync()
                   ?? throw new BusinessException("Odabrani termin ne postoji.");

        if (!slot.IsActive)
        {
            throw new BusinessException("Aktivnost trenutno nije dostupna za rezervaciju.");
        }

        if (slot.StartTime <= DateTime.UtcNow)
        {
            throw new BusinessException("Termin je već počeo ili završio i ne može se rezervisati.");
        }

        var userId = currentUser.UserId;

        var alreadyBooked = await dbContext.ActivityReservations.AnyAsync(x =>
            x.ActivitySlotId == slot.Id &&
            x.UserId == userId &&
            ReservationRules.ActiveStatuses.Contains(x.Status));

        if (alreadyBooked)
        {
            throw new BusinessException("Već imate aktivnu rezervaciju za ovaj termin.");
        }

        var bookedCount = await dbContext.ActivityReservations
            .Where(x => x.ActivitySlotId == slot.Id && ReservationRules.ActiveStatuses.Contains(x.Status))
            .SumAsync(x => x.ParticipantCount);

        var availableSpots = slot.Capacity - bookedCount;

        if (request.ParticipantCount > availableSpots)
        {
            throw new BusinessException(availableSpots > 0
                ? $"Za ovaj termin je slobodno još samo {availableSpots} mjesta."
                : "Termin je popunjen.");
        }

        var now = DateTime.UtcNow;

        var reservation = new ActivityReservation
        {
            ActivitySlotId = slot.Id,
            ParticipantCount = request.ParticipantCount,
            StartTime = slot.StartTime,
            EndTime = slot.EndTime,
            TotalPrice = request.ParticipantCount * slot.PricePerPerson,
            Note = string.IsNullOrWhiteSpace(request.Note) ? null : request.Note.Trim(),
            Status = ReservationStatus.Pending,
            UserId = userId,
            CreatedAt = now
        };

        ReservationHistory.Record(reservation, null, ReservationStatus.Pending, userId, "Rezervacija kreirana.", now);

        dbContext.ActivityReservations.Add(reservation);
        await dbContext.SaveChangesAsync();
        await transaction.CommitAsync();

        return await dbContext.GetResponseAsync(reservation.Id);
    }
}
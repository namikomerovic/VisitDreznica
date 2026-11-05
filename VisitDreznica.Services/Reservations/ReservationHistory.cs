using VisitDreznica.Model.Enums;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Reservations;

public static class ReservationHistory
{
    public static void Record(Reservation reservation, ReservationStatus? fromStatus, ReservationStatus toStatus,
        int changedByUserId, string? comment, DateTime changedAt)
    {
        reservation.StatusHistory.Add(new ReservationStatusHistory
        {
            FromStatus = fromStatus,
            ToStatus = toStatus,
            ChangedByUserId = changedByUserId,
            ChangedAt = changedAt,
            Comment = comment
        });
    }
}
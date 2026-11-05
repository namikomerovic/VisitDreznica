using VisitDreznica.Model.Enums;

namespace VisitDreznica.Services.Reservations;

public static class ReservationRules
{
    public static readonly ReservationStatus[] ActiveStatuses = [ReservationStatus.Pending, ReservationStatus.Confirmed];
}
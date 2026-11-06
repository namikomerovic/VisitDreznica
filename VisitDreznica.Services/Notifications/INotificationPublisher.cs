namespace VisitDreznica.Services.Notifications;

public interface INotificationPublisher
{
    Task ReservationStatusChangedAsync(int reservationId);
    Task ReservationPaidAsync(int reservationId);
}
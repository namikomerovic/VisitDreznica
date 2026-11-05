namespace VisitDreznica.Services.Messaging;

public interface IReservationEmailService
{
    Task NotifyStatusChangedAsync(int reservationId);
}
namespace VisitDreznica.Services.Payments;

public interface IReservationPaymentService
{
    Task<bool> SyncAsync(int reservationId);
    Task ReverseAsync(int reservationId, string reason);
}
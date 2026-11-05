namespace VisitDreznica.Services.Reservations;

public interface IReservationExpiryService
{
    Task<int> ExpireUnpaidAsync(CancellationToken cancellationToken);
}
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using VisitDreznica.Model.Enums;
using VisitDreznica.Services.Database;
using VisitDreznica.Services.Messaging;
using VisitDreznica.Services.Payments;
using VisitDreznica.Services.Reservations.StateMachine;

namespace VisitDreznica.Services.Reservations;

public class ReservationExpiryService(
    VisitDreznicaDbContext dbContext,
    IReservationPaymentService reservationPaymentService,
    IReservationEmailService reservationEmailService,
    PaymentSettings settings,
    ILogger<ReservationExpiryService> logger) : IReservationExpiryService
{
    private const int BatchSize = 50;

    public async Task<int> ExpireUnpaidAsync(CancellationToken cancellationToken)
    {
        var now = DateTime.UtcNow;
        var cutoff = now.AddMinutes(-settings.UnpaidReservationExpiryMinutes);
        var reason = $"Automatski otkazano: rezervacija nije plaćena u roku od {settings.UnpaidReservationExpiryMinutes} minuta.";

        var candidateIds = await dbContext.Reservations
            .Where(x => x.Status == ReservationStatus.Pending &&
                        x.CreatedAt <= cutoff &&
                        !x.Payments.Any(p => p.Status == PaymentStatus.Succeeded))
            .OrderBy(x => x.CreatedAt)
            .Select(x => x.Id)
            .Take(BatchSize)
            .ToListAsync(cancellationToken);

        var expiredCount = 0;

        foreach (var id in candidateIds)
        {
            try
            {
                if (await reservationPaymentService.SyncAsync(id))
                {
                    await dbContext.SaveChangesAsync(cancellationToken);
                    continue;
                }

                var reservation = await dbContext.Reservations.FirstAsync(x => x.Id == id, cancellationToken);

                if (reservation.Status != ReservationStatus.Pending)
                {
                    continue;
                }

                var fromStatus = reservation.Status;
                ReservationStateMachine.For(fromStatus)
                    .Cancel(reservation, new TransitionContext(IsAdmin: true, Reason: reason, Now: now, IsPaid: false));

                reservation.UpdatedAt = now;
                ReservationHistory.Record(reservation, fromStatus, reservation.Status, null, reason, now);

                                await reservationPaymentService.ReverseAsync(id, reason);
                await dbContext.SaveChangesAsync(cancellationToken);

                expiredCount++;

                await reservationEmailService.NotifyStatusChangedAsync(id);
            }
            catch (Exception ex) when (ex is not OperationCanceledException)
            {
                logger.LogError(ex, "Automatsko otkazivanje rezervacije {ReservationId} nije uspjelo", id);
                dbContext.ChangeTracker.Clear();
            }
        }

        return expiredCount;
    }
}
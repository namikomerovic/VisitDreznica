using VisitDreznica.Services.Reservations;

namespace VisitDreznica.API.BackgroundServices;

public class ReservationExpiryWorker(
    IServiceScopeFactory scopeFactory,
    ILogger<ReservationExpiryWorker> logger) : BackgroundService
{
    private static readonly TimeSpan Interval = TimeSpan.FromMinutes(1);

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        using var timer = new PeriodicTimer(Interval);

        do
        {
            try
            {
                using var scope = scopeFactory.CreateScope();
                var expiryService = scope.ServiceProvider.GetRequiredService<IReservationExpiryService>();

                var expired = await expiryService.ExpireUnpaidAsync(stoppingToken);

                if (expired > 0)
                {
                    logger.LogInformation("Automatski otkazano {Count} neplaćenih rezervacija", expired);
                }
            }
            catch (Exception ex) when (ex is not OperationCanceledException)
            {
                logger.LogError(ex, "Greška pri automatskom otkazivanju rezervacija");
            }
        }
        while (await timer.WaitForNextTickAsync(stoppingToken));
    }
}
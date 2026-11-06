using VisitDreznica.Services.Recommendations;

namespace VisitDreznica.API.BackgroundServices;

public class RecommenderTrainingWorker(
    IServiceScopeFactory scopeFactory,
    ILogger<RecommenderTrainingWorker> logger) : BackgroundService
{
    private static readonly TimeSpan Interval = TimeSpan.FromHours(6);

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        using var timer = new PeriodicTimer(Interval);

        do
        {
            try
            {
                using var scope = scopeFactory.CreateScope();
                var trainer = scope.ServiceProvider.GetRequiredService<IRecommenderTrainer>();
                await trainer.TrainAsync(stoppingToken);
            }
            catch (Exception ex) when (ex is not OperationCanceledException)
            {
                logger.LogError(ex, "Treniranje modela preporuka nije uspjelo");
            }
        }
        while (await timer.WaitForNextTickAsync(stoppingToken));
    }
}
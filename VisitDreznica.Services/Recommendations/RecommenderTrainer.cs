using Microsoft.Extensions.Logging;
using Microsoft.ML;
using Microsoft.ML.Trainers;
using VisitDreznica.Model.Responses;
using VisitDreznica.Services.Database;

namespace VisitDreznica.Services.Recommendations;

public class RecommenderTrainer(
    VisitDreznicaDbContext dbContext,
    IRecommenderModelStore store,
    ILogger<RecommenderTrainer> logger) : IRecommenderTrainer
{
    private const int MinInteractions = 20;
    private const int MinUsers = 3;
    private const int MinItems = 3;
    private const int Seed = 42;

    public async Task<RecommenderModelResponse> TrainAsync(CancellationToken cancellationToken)
    {
        await store.TrainingLock.WaitAsync(cancellationToken);

        try
        {
            var scores = await InteractionDataLoader.LoadAsync(dbContext, cancellationToken);
            var snapshot = await Task.Run(() => Train(scores), cancellationToken);

            store.Set(snapshot);

            logger.LogInformation(
                "Model preporuka: {Interactions} interakcija, treniran: {Trained}, RMSE {Rmse}, baseline {Baseline}",
                snapshot.InteractionCount, snapshot.Model is not null, snapshot.Rmse, snapshot.BaselineRmse);

            return snapshot.ToResponse();
        }
        finally
        {
            store.TrainingLock.Release();
        }
    }

    private static RecommenderSnapshot Train(List<UserItemScore> scores)
    {
        var userItems = scores.GroupBy(x => x.UserId)
            .ToDictionary(g => g.Key, g => g.ToDictionary(x => x.ItemKey, x => x.Score));

        var itemUsers = scores.GroupBy(x => x.ItemKey)
            .ToDictionary(g => g.Key, g => g.ToDictionary(x => x.UserId, x => x.Score));

        var globalMean = scores.Count == 0 ? 0 : scores.Average(x => (double)x.Score);

        RecommenderSnapshot Snapshot(ITransformer? model, Evaluation? evaluation, string? note) => new()
        {
            TrainedAt = DateTime.UtcNow,
            Model = model,
            UserItems = userItems,
            ItemUsers = itemUsers,
            GlobalMean = globalMean,
            InteractionCount = scores.Count,
            Rmse = evaluation?.Rmse,
            Mae = evaluation?.Mae,
            BaselineRmse = evaluation?.BaselineRmse,
            EvaluatedCount = evaluation?.Count ?? 0,
            Note = note
        };

        if (scores.Count < MinInteractions || userItems.Count < MinUsers || itemUsers.Count < MinItems)
        {
            return Snapshot(null, null,
                $"Premalo podataka za treniranje (potrebno najmanje {MinInteractions} interakcija, {MinUsers} gosta i {MinItems} stavke). Koriste se popularne stavke.");
        }

        var ml = new MLContext(seed: Seed);

        var rows = scores
            .Select(x => new InteractionRow { User = x.UserId.ToString(), Item = x.ItemKey, Label = x.Score })
            .ToList();

        var data = ml.Data.LoadFromEnumerable(rows);
        var split = ml.Data.TrainTestSplit(data, testFraction: 0.2, seed: Seed);

        var pipeline = ml.Transforms.Conversion.MapValueToKey("UserKey", nameof(InteractionRow.User))
            .Append(ml.Transforms.Conversion.MapValueToKey("ItemKey", nameof(InteractionRow.Item)))
            .Append(ml.Recommendation().Trainers.MatrixFactorization(new MatrixFactorizationTrainer.Options
            {
                MatrixColumnIndexColumnName = "UserKey",
                MatrixRowIndexColumnName = "ItemKey",
                LabelColumnName = nameof(InteractionRow.Label),
                ApproximationRank = 8,
                NumberOfIterations = 50,
                LearningRate = 0.1,
                Lambda = 0.05,
                Quiet = true
            }));

        var evaluationModel = pipeline.Fit(split.TrainSet);
        var evaluation = Evaluate(ml, evaluationModel, split);

        var model = pipeline.Fit(data);

        return Snapshot(model, evaluation, null);
    }

    private static Evaluation? Evaluate(MLContext ml, ITransformer model, DataOperationsCatalog.TrainTestData split)
    {
        var trainMean = ml.Data.CreateEnumerable<InteractionRow>(split.TrainSet, reuseRowObject: false)
            .Average(x => (double)x.Label);

        var predictions = ml.Data.CreateEnumerable<ScoredRow>(model.Transform(split.TestSet), reuseRowObject: false)
            .Where(x => !float.IsNaN(x.Score))
            .ToList();

        if (predictions.Count == 0)
        {
            return null;
        }

        var rmse = Math.Sqrt(predictions.Average(x => Math.Pow(x.Label - Math.Clamp(x.Score, 1f, 5f), 2)));
        var mae = predictions.Average(x => Math.Abs(x.Label - Math.Clamp(x.Score, 1f, 5f)));
        var baselineRmse = Math.Sqrt(predictions.Average(x => Math.Pow(x.Label - trainMean, 2)));

        return new Evaluation(rmse, mae, baselineRmse, predictions.Count);
    }

    private sealed record Evaluation(double Rmse, double Mae, double BaselineRmse, int Count);
}
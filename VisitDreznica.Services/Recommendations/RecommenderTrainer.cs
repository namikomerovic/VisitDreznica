using Microsoft.Extensions.Logging;
using VisitDreznica.Model.Responses;
using VisitDreznica.Services.Database;

namespace VisitDreznica.Services.Recommendations;

public class RecommenderTrainer(
    VisitDreznicaDbContext dbContext,
    IRecommenderModelStore store,
    ILogger<RecommenderTrainer> logger) : IRecommenderTrainer
{
    private const int MinPositives = 20;
    private const int MinUsers = 3;
    private const int MinItems = 3;
    private const int Folds = 5;
    private const int TopK = 3;
    private const int Seed = 42;

    private static readonly MfConfig[] Candidates =
    [
        new(4, 0.025, 0.01),
        new(4, 0.1, 0.01),
        new(8, 0.025, 0.01),
        new(8, 0.1, 0.01),
        new(8, 0.1, 0.1),
        new(16, 0.1, 0.01)
    ];

    public async Task<RecommenderModelResponse> TrainAsync(CancellationToken cancellationToken)
    {
        await store.TrainingLock.WaitAsync(cancellationToken);

        try
        {
            var scores = await InteractionDataLoader.LoadAsync(dbContext, cancellationToken);
            var snapshot = await Task.Run(() => Train(scores), cancellationToken);

            store.Set(snapshot);

            logger.LogInformation(
                "Model preporuka: {Positives} izbora, treniran: {Trained}, HitRate@{K} {HitRate} " +
                "(popularnost {Popularity}, slučajno {Random}), rank {Rank}, lambda {Lambda}, alpha {Alpha}",
                snapshot.PositiveCount, snapshot.Model is not null, snapshot.TopK, snapshot.HitRate,
                snapshot.PopularityHitRate, snapshot.RandomHitRate,
                snapshot.Config?.Rank, snapshot.Config?.Lambda, snapshot.Config?.Alpha);

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

        var positives = scores.Where(x => x.Score >= InteractionWeights.PositiveThreshold).ToList();
        var positiveUsers = positives.Select(x => x.UserId).Distinct().Count();
        var positiveItems = positives.Select(x => x.ItemKey).Distinct().Count();

        if (positives.Count < MinPositives || positiveUsers < MinUsers || positiveItems < MinItems)
        {
            return new RecommenderSnapshot
            {
                TrainedAt = DateTime.UtcNow,
                UserItems = userItems,
                ItemUsers = itemUsers,
                GlobalMean = globalMean,
                InteractionCount = scores.Count,
                PositiveCount = positives.Count,
                TopK = TopK,
                Note = $"Premalo podataka za treniranje (potrebno najmanje {MinPositives} izbora, " +
                       $"{MinUsers} gosta i {MinItems} stavke). Koriste se popularne stavke."
            };
        }

        var itemKeys = itemUsers.Keys.OrderBy(x => x, StringComparer.Ordinal).ToList();

        var best = Candidates
            .Select(config => Evaluate(positives, itemKeys, config))
            .OrderByDescending(x => x.HitRate)
            .ThenBy(x => x.Config.Rank)
            .First();

        return new RecommenderSnapshot
        {
            TrainedAt = DateTime.UtcNow,
            Model = ImplicitMfModel.Fit(positives, best.Config, Seed),
            UserItems = userItems,
            ItemUsers = itemUsers,
            GlobalMean = globalMean,
            InteractionCount = scores.Count,
            PositiveCount = positives.Count,
            TopK = TopK,
            HitRate = best.HitRate,
            PopularityHitRate = best.PopularityHitRate,
            RandomHitRate = best.RandomHitRate,
            EvaluatedCount = best.Count,
            Config = best.Config
        };
    }

    private static RankingResult Evaluate(List<UserItemScore> positives, List<string> itemKeys, MfConfig config)
    {
        var rng = new Random(Seed);

        var shuffledByUser = positives
            .GroupBy(x => x.UserId)
            .Where(g => g.Count() >= 2)
            .OrderBy(g => g.Key)
            .ToDictionary(
                g => g.Key,
                g => g.OrderBy(x => x.ItemKey, StringComparer.Ordinal).OrderBy(_ => rng.Next()).ToList());

        int tests = 0, modelHits = 0, popularityHits = 0;
        double randomExpected = 0;

        for (var fold = 0; fold < Folds; fold++)
        {
            var heldOut = shuffledByUser
                .SelectMany(x => x.Value.Where((_, index) => index % Folds == fold))
                .ToList();

            if (heldOut.Count == 0)
            {
                continue;
            }

            var heldOutKeys = heldOut.Select(x => (x.UserId, x.ItemKey)).ToHashSet();
            var train = positives.Where(x => !heldOutKeys.Contains((x.UserId, x.ItemKey))).ToList();

            var model = ImplicitMfModel.Fit(train, config, Seed);

            var popularity = train.GroupBy(x => x.ItemKey).ToDictionary(g => g.Key, g => g.Count());
            var seenByUser = train.GroupBy(x => x.UserId)
                .ToDictionary(g => g.Key, g => g.Select(x => x.ItemKey).ToHashSet());

            foreach (var userTests in heldOut.GroupBy(x => x.UserId))
            {
                var seen = seenByUser.GetValueOrDefault(userTests.Key) ?? [];
                var candidates = itemKeys.Where(x => !seen.Contains(x)).ToList();

                if (candidates.Count == 0)
                {
                    continue;
                }

                var scores = model.Predict(candidates.Select(x => (userTests.Key, x)).ToList());

                var modelTop = candidates
                    .Select((key, index) => (Key: key, Score: scores[index]))
                    .OrderByDescending(x => x.Score)
                    .ThenBy(x => x.Key, StringComparer.Ordinal)
                    .Take(TopK)
                    .Select(x => x.Key)
                    .ToHashSet();

                var popularTop = candidates
                    .OrderByDescending(x => popularity.GetValueOrDefault(x))
                    .ThenBy(x => x, StringComparer.Ordinal)
                    .Take(TopK)
                    .ToHashSet();

                foreach (var test in userTests)
                {
                    tests++;

                    if (modelTop.Contains(test.ItemKey)) modelHits++;
                    if (popularTop.Contains(test.ItemKey)) popularityHits++;

                    randomExpected += Math.Min(TopK, candidates.Count) / (double)candidates.Count;
                }
            }
        }

        return tests == 0
            ? new RankingResult(config, 0, 0, 0, 0)
            : new RankingResult(config, modelHits / (double)tests, popularityHits / (double)tests,
                randomExpected / tests, tests);
    }

    private sealed record RankingResult(
        MfConfig Config, double HitRate, double PopularityHitRate, double RandomHitRate, int Count);
}
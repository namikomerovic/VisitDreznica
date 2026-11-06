using Microsoft.ML;
using Microsoft.ML.Trainers;

namespace VisitDreznica.Services.Recommendations;

public sealed record MfConfig(int Rank, double Lambda, double Alpha);

public sealed class ImplicitMfModel
{
    private const int Iterations = 50;
    private const double NegativeTarget = 0.00001;

    private readonly ITransformer factors;
    private readonly HashSet<int> users;
    private readonly HashSet<string> items;

    private ImplicitMfModel(ITransformer factors, HashSet<int> users, HashSet<string> items)
    {
        this.factors = factors;
        this.users = users;
        this.items = items;
    }

    public bool KnowsUser(int userId) => users.Contains(userId);

    public bool KnowsItem(string itemKey) => items.Contains(itemKey);

    public static ImplicitMfModel Fit(IReadOnlyList<UserItemScore> positives, MfConfig config, int seed)
    {
        var ml = new MLContext(seed);

        var rows = positives.Select(x => new InteractionRow
        {
            User = x.UserId.ToString(),
            Item = x.ItemKey,
            Label = x.Score / 5f
        });

        var pipeline = ml.Transforms.Conversion.MapValueToKey("UserKey", nameof(InteractionRow.User))
            .Append(ml.Transforms.Conversion.MapValueToKey("ItemKey", nameof(InteractionRow.Item)))
            .Append(ml.Recommendation().Trainers.MatrixFactorization(new MatrixFactorizationTrainer.Options
            {
                MatrixColumnIndexColumnName = "UserKey",
                MatrixRowIndexColumnName = "ItemKey",
                LabelColumnName = nameof(InteractionRow.Label),
                LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass,
                ApproximationRank = config.Rank,
                Lambda = config.Lambda,
                Alpha = config.Alpha,
                C = NegativeTarget,
                NumberOfIterations = Iterations,
                NumberOfThreads = 1,
                Quiet = true
            }));

        var factors = pipeline.Fit(ml.Data.LoadFromEnumerable(rows));

        return new ImplicitMfModel(
            factors,
            positives.Select(x => x.UserId).ToHashSet(),
            positives.Select(x => x.ItemKey).ToHashSet());
    }

    public double[] Predict(IReadOnlyList<(int UserId, string ItemKey)> pairs)
    {
        if (pairs.Count == 0)
        {
            return [];
        }

        var ml = new MLContext();

        var input = ml.Data.LoadFromEnumerable(pairs.Select(x => new InteractionRow
        {
            User = x.UserId.ToString(),
            Item = x.ItemKey
        }));

        return ml.Data.CreateEnumerable<FactorScoreRow>(factors.Transform(input), reuseRowObject: false)
            .Select(x => float.IsNaN(x.Score) ? double.NegativeInfinity : x.Score)
            .ToArray();
    }
}
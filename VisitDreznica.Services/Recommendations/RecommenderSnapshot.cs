using VisitDreznica.Model.Responses;

namespace VisitDreznica.Services.Recommendations;

public sealed class RecommenderSnapshot
{
    public required DateTime TrainedAt { get; init; }
    public ImplicitMfModel? Model { get; init; }
    public required IReadOnlyDictionary<int, Dictionary<string, float>> UserItems { get; init; }
    public required IReadOnlyDictionary<string, Dictionary<int, float>> ItemUsers { get; init; }
    public required double GlobalMean { get; init; }
    public required int InteractionCount { get; init; }
    public int PositiveCount { get; init; }
    public int TopK { get; init; }
    public double? HitRate { get; init; }
    public double? PopularityHitRate { get; init; }
    public double? RandomHitRate { get; init; }
    public int EvaluatedCount { get; init; }
    public MfConfig? Config { get; init; }
    public string? Note { get; init; }

    public RecommenderModelResponse ToResponse() => new()
    {
        TrainedAt = TrainedAt,
        IsModelTrained = Model is not null,
        InteractionCount = InteractionCount,
        PositiveCount = PositiveCount,
        UserCount = UserItems.Count,
        ItemCount = ItemUsers.Count,
        TopK = Model is not null ? TopK : null,
        HitRate = Round(HitRate),
        PopularityHitRate = Round(PopularityHitRate),
        RandomHitRate = Round(RandomHitRate),
        EvaluatedCount = EvaluatedCount,
        SelectedRank = Config?.Rank,
        SelectedLambda = Config?.Lambda,
        SelectedAlpha = Config?.Alpha,
        EvaluationMethod = Model is not null ? $"Skrivena stavka po gostu, 5 foldova, HitRate@{TopK}" : null,
        Note = Note
    };

    private static double? Round(double? value) => value.HasValue ? Math.Round(value.Value, 3) : null;
}
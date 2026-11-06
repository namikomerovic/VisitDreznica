using Microsoft.ML;
using VisitDreznica.Model.Responses;

namespace VisitDreznica.Services.Recommendations;

public sealed class RecommenderSnapshot
{
    public required DateTime TrainedAt { get; init; }
    public ITransformer? Model { get; init; }
    public required IReadOnlyDictionary<int, Dictionary<string, float>> UserItems { get; init; }
    public required IReadOnlyDictionary<string, Dictionary<int, float>> ItemUsers { get; init; }
    public required double GlobalMean { get; init; }
    public required int InteractionCount { get; init; }
    public double? Rmse { get; init; }
    public double? Mae { get; init; }
    public double? BaselineRmse { get; init; }
    public int EvaluatedCount { get; init; }
    public string? Note { get; init; }

    public RecommenderModelResponse ToResponse() => new()
    {
        TrainedAt = TrainedAt,
        IsModelTrained = Model is not null,
        InteractionCount = InteractionCount,
        UserCount = UserItems.Count,
        ItemCount = ItemUsers.Count,
        Rmse = Rmse.HasValue ? Math.Round(Rmse.Value, 3) : null,
        Mae = Mae.HasValue ? Math.Round(Mae.Value, 3) : null,
        BaselineRmse = BaselineRmse.HasValue ? Math.Round(BaselineRmse.Value, 3) : null,
        EvaluatedCount = EvaluatedCount,
        Note = Note
    };
}
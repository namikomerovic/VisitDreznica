namespace VisitDreznica.Model.Responses;

public class RecommenderModelResponse
{
    public DateTime? TrainedAt { get; set; }
    public bool IsModelTrained { get; set; }
    public int InteractionCount { get; set; }
    public int PositiveCount { get; set; }
    public int UserCount { get; set; }
    public int ItemCount { get; set; }
    public int? TopK { get; set; }
    public double? HitRate { get; set; }
    public double? PopularityHitRate { get; set; }
    public double? RandomHitRate { get; set; }
    public int EvaluatedCount { get; set; }
    public int? SelectedRank { get; set; }
    public double? SelectedLambda { get; set; }
    public double? SelectedAlpha { get; set; }
    public string? EvaluationMethod { get; set; }
    public string? Note { get; set; }
}
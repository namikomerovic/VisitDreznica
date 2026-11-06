namespace VisitDreznica.Model.Responses;

public class RecommenderModelResponse
{
    public DateTime? TrainedAt { get; set; }
    public bool IsModelTrained { get; set; }
    public int InteractionCount { get; set; }
    public int UserCount { get; set; }
    public int ItemCount { get; set; }
    public double? Rmse { get; set; }
    public double? Mae { get; set; }
    public double? BaselineRmse { get; set; }
    public int EvaluatedCount { get; set; }
    public string? Note { get; set; }
}
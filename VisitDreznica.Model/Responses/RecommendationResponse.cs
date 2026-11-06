using VisitDreznica.Model.Enums;

namespace VisitDreznica.Model.Responses;

public class RecommendationResponse
{
    public ItemType ItemType { get; set; }
    public int ItemId { get; set; }
    public string ItemName { get; set; } = string.Empty;
    public double Score { get; set; }
    public string Reason { get; set; } = string.Empty;
    public bool IsPersonalized { get; set; }
}
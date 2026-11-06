namespace VisitDreznica.Services.Recommendations;

public sealed record UserItemScore(int UserId, string ItemKey, float Score, bool IsExplicit);

public class InteractionRow
{
    public string User { get; set; } = string.Empty;
    public string Item { get; set; } = string.Empty;
    public float Label { get; set; }
}

public class FactorScoreRow
{
    public float Score { get; set; }
}
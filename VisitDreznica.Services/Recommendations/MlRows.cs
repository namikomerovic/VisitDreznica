namespace VisitDreznica.Services.Recommendations;

public sealed record UserItemScore(int UserId, string ItemKey, float Score, bool IsExplicit);

public class InteractionRow
{
    public string User { get; set; } = string.Empty;
    public string Item { get; set; } = string.Empty;
    public float Label { get; set; }
}

public class ScoredRow
{
    public float Label { get; set; }
    public float Score { get; set; }
}

public class ItemScoreRow
{
    public string Item { get; set; } = string.Empty;
    public float Score { get; set; }
}
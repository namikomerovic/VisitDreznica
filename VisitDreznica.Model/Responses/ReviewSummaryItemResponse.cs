namespace VisitDreznica.Model.Responses;

public class ReviewSummaryItemResponse
{
    public int ItemId { get; set; }
    public double AverageRating { get; set; }
    public int ReviewCount { get; set; }
}
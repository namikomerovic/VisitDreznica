namespace VisitDreznica.Model.Responses;

public class ReviewSummaryResponse
{
    public double? AverageRating { get; set; }
    public int ReviewCount { get; set; }
    public List<int> RatingCounts { get; set; } = [];
    public bool CanReview { get; set; }
    public ReviewResponse? MyReview { get; set; }
}
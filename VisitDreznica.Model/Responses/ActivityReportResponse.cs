namespace VisitDreznica.Model.Responses;

public class ActivityReportResponse
{
    public DateOnly From { get; set; }
    public DateOnly To { get; set; }
    public List<ActivityPerformanceResponse> Activities { get; set; } = [];
    public List<PlaceRatingResponse> Places { get; set; } = [];
}

public class ActivityPerformanceResponse
{
    public string Name { get; set; } = string.Empty;
    public int SlotCount { get; set; }
    public int Capacity { get; set; }
    public int Participants { get; set; }
    public double FillPercent { get; set; }
    public decimal Revenue { get; set; }
    public double? AverageRating { get; set; }
    public int ReviewCount { get; set; }
}

public class PlaceRatingResponse
{
    public string Name { get; set; } = string.Empty;
    public double? AverageRating { get; set; }
    public int ReviewCount { get; set; }
    public int FavoriteCount { get; set; }
    public int ViewCount { get; set; }
}
using VisitDreznica.Model.Enums;

namespace VisitDreznica.Model.Responses;

public class DashboardResponse
{
    public decimal RevenueThisMonth { get; set; }
    public decimal RevenueLastMonth { get; set; }
    public int ReservationsThisMonth { get; set; }
    public int AwaitingConfirmation { get; set; }
    public int UpcomingArrivals { get; set; }
    public double? AverageRating { get; set; }
    public int ReviewCount { get; set; }
    public int GuestCount { get; set; }
    public List<MonthlyRevenueResponse> RevenueByMonth { get; set; } = [];
    public List<StatusCountResponse> ReservationsByStatus { get; set; } = [];
    public List<TopItemResponse> TopItems { get; set; } = [];
}

public class MonthlyRevenueResponse
{
    public int Year { get; set; }
    public int Month { get; set; }
    public decimal Rooms { get; set; }
    public decimal Equipment { get; set; }
    public decimal Activities { get; set; }
    public decimal Total { get; set; }
}

public class StatusCountResponse
{
    public ReservationStatus Status { get; set; }
    public int Count { get; set; }
}

public class TopItemResponse
{
    public string Name { get; set; } = string.Empty;
    public string Type { get; set; } = string.Empty;
    public int ReservationCount { get; set; }
    public decimal Revenue { get; set; }
}
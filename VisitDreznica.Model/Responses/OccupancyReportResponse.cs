namespace VisitDreznica.Model.Responses;

public class OccupancyReportResponse
{
    public DateOnly From { get; set; }
    public DateOnly To { get; set; }
    public int DaysInPeriod { get; set; }
    public int TotalAvailableNights { get; set; }
    public int TotalBookedNights { get; set; }
    public double OccupancyPercent { get; set; }
    public decimal Revenue { get; set; }
    public List<RoomOccupancyResponse> Rooms { get; set; } = [];
}

public class RoomOccupancyResponse
{
    public string RoomName { get; set; } = string.Empty;
    public int AvailableNights { get; set; }
    public int BookedNights { get; set; }
    public double OccupancyPercent { get; set; }
    public int ReservationCount { get; set; }
    public double AverageStayNights { get; set; }
    public decimal Revenue { get; set; }
}
namespace VisitDreznica.Model.Responses;

public class ActivitySlotResponse
{
    public int Id { get; set; }
    public int ActivityId { get; set; }
    public string ActivityName { get; set; } = string.Empty;
    public DateTime StartTime { get; set; }
    public DateTime EndTime { get; set; }
    public int Capacity { get; set; }
    public int GuideId { get; set; }
    public string GuideFullName { get; set; } = string.Empty;
    public int BookedCount { get; set; }
    public int AvailableSpots { get; set; }
}
namespace VisitDreznica.Model.Responses;

public class ActivityResponse
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public int ActivityCategoryId { get; set; }
    public string ActivityCategoryName { get; set; } = string.Empty;
    public int DurationMinutes { get; set; }
    public int MaxParticipants { get; set; }
    public decimal PricePerPerson { get; set; }
    public string? MeetingPoint { get; set; }
    public bool IsActive { get; set; }
    public bool HasImage { get; set; }
    public DateTime? NextSlotStart { get; set; }
}
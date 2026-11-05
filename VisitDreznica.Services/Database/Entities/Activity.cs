namespace VisitDreznica.Services.Database.Entities;

public class Activity : IHasImage
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public int DurationMinutes { get; set; }
    public int MaxParticipants { get; set; }
    public decimal PricePerPerson { get; set; }
    public string? MeetingPoint { get; set; }
    public bool IsActive { get; set; } = true;
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }

    public byte[]? ImageData { get; set; }
    public string? ImageContentType { get; set; }

    public int ActivityCategoryId { get; set; }
    public ActivityCategory ActivityCategory { get; set; } = null!;

    public ICollection<ActivitySlot> Slots { get; set; } = new List<ActivitySlot>();
}
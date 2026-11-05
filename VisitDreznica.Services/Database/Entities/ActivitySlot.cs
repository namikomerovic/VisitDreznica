namespace VisitDreznica.Services.Database.Entities;

public class ActivitySlot : IEntity
{
    public int Id { get; set; }
    public DateTime StartTime { get; set; }
    public DateTime EndTime { get; set; }
    public int Capacity { get; set; }
    public DateTime CreatedAt { get; set; }

    public int ActivityId { get; set; }
    public Activity Activity { get; set; } = null!;

    public int GuideId { get; set; }
    public Guide Guide { get; set; } = null!;

    public ICollection<ActivityReservation> Reservations { get; set; } = new List<ActivityReservation>();
}
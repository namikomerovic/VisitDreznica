using VisitDreznica.Model.Enums;

namespace VisitDreznica.Services.Database.Entities;

public class Notification : IEntity
{
    public int Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Message { get; set; } = string.Empty;
    public NotificationType Type { get; set; }
    public bool IsRead { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? ReadAt { get; set; }

    public int UserId { get; set; }
    public User User { get; set; } = null!;

    public int? ReservationId { get; set; }
    public Reservation? Reservation { get; set; }
}
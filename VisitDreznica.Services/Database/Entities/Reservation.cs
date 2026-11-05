using VisitDreznica.Model.Enums;

namespace VisitDreznica.Services.Database.Entities;

public abstract class Reservation : IEntity
{
    public int Id { get; set; }
    public ReservationStatus Status { get; set; } = ReservationStatus.Pending;
    public DateTime StartTime { get; set; }
    public DateTime EndTime { get; set; }
    public decimal TotalPrice { get; set; }
    public string? Note { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }

    public int UserId { get; set; }
    public User User { get; set; } = null!;

    public ICollection<ReservationStatusHistory> StatusHistory { get; set; } = new List<ReservationStatusHistory>();
    public ICollection<Payment> Payments { get; set; } = new List<Payment>();
}
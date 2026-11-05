using VisitDreznica.Model.Enums;

namespace VisitDreznica.Services.Database.Entities;

public class ReservationStatusHistory : IEntity
{
    public int Id { get; set; }
    public ReservationStatus? FromStatus { get; set; }
    public ReservationStatus ToStatus { get; set; }
    public DateTime ChangedAt { get; set; }
    public string? Comment { get; set; }

    public int ReservationId { get; set; }
    public Reservation Reservation { get; set; } = null!;

    public int ChangedByUserId { get; set; }
    public User ChangedByUser { get; set; } = null!;
}
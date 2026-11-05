using VisitDreznica.Model.Enums;

namespace VisitDreznica.Services.Database.Entities;

public class Payment : IEntity
{
    public int Id { get; set; }
    public string StripePaymentIntentId { get; set; } = string.Empty;
    public decimal Amount { get; set; }
    public string Currency { get; set; } = string.Empty;
    public PaymentStatus Status { get; set; } = PaymentStatus.Pending;
    public DateTime CreatedAt { get; set; }
    public DateTime? PaidAt { get; set; }

    public int ReservationId { get; set; }
    public Reservation Reservation { get; set; } = null!;

    public ICollection<Refund> Refunds { get; set; } = new List<Refund>();
}
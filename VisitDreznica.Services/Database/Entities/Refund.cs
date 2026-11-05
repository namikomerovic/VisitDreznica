namespace VisitDreznica.Services.Database.Entities;

public class Refund : IEntity
{
    public int Id { get; set; }
    public string StripeRefundId { get; set; } = string.Empty;
    public decimal Amount { get; set; }
    public string? Reason { get; set; }
    public DateTime CreatedAt { get; set; }

    public int PaymentId { get; set; }
    public Payment Payment { get; set; } = null!;
}
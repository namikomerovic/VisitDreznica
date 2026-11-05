namespace VisitDreznica.Services.Payments;

public sealed class PaymentSettings
{
    public required string SecretKey { get; init; }
    public required string PublishableKey { get; init; }
    public required string Currency { get; init; }
}
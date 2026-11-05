namespace VisitDreznica.Services.Payments;

internal static class StripeHelper
{
    public const string Succeeded = "succeeded";
    public const string Canceled = "canceled";

    public static readonly string[] OpenStatuses = ["requires_payment_method", "requires_confirmation", "requires_action"];

    public static long ToMinorUnits(decimal amount) => (long)Math.Round(amount * 100, MidpointRounding.AwayFromZero);

    public static decimal FromMinorUnits(long amount) => amount / 100m;
}
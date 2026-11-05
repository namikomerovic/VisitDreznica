using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Stripe;
using VisitDreznica.Model.Enums;
using VisitDreznica.Services.Database;
using Payment = VisitDreznica.Services.Database.Entities.Payment;
using Refund = VisitDreznica.Services.Database.Entities.Refund;

namespace VisitDreznica.Services.Payments;

public class ReservationPaymentService(
    VisitDreznicaDbContext dbContext,
    IStripeClient stripeClient,
    ILogger<ReservationPaymentService> logger) : IReservationPaymentService
{
    public async Task<bool> SyncAsync(int reservationId)
    {
        var payments = await dbContext.Payments
            .Where(x => x.ReservationId == reservationId &&
                        (x.Status == PaymentStatus.Pending || x.Status == PaymentStatus.Succeeded))
            .ToListAsync();

        var intentService = new PaymentIntentService(stripeClient);

        foreach (var payment in payments.Where(x => x.Status == PaymentStatus.Pending))
        {
            var intent = await intentService.GetAsync(payment.StripePaymentIntentId);

            if (intent.Status == StripeHelper.Succeeded)
            {
                MarkSucceeded(payment, intent);
            }
        }

        return payments.Any(x => x.Status == PaymentStatus.Succeeded);
    }

    public async Task ReverseAsync(int reservationId, string reason)
    {
        var payments = await dbContext.Payments
            .Where(x => x.ReservationId == reservationId &&
                        (x.Status == PaymentStatus.Pending || x.Status == PaymentStatus.Succeeded))
            .ToListAsync();

        foreach (var payment in payments)
        {
            if (payment.Status == PaymentStatus.Succeeded)
            {
                await RefundAsync(payment, reason);
            }
            else
            {
                await CancelOpenIntentAsync(payment, reason);
            }
        }
    }

    private async Task RefundAsync(Payment payment, string reason)
    {
        var stripeRefund = await new RefundService(stripeClient).CreateAsync(
            new RefundCreateOptions
            {
                PaymentIntent = payment.StripePaymentIntentId,
                Amount = StripeHelper.ToMinorUnits(payment.Amount),
                Metadata = new Dictionary<string, string>
                {
                    ["reservationId"] = payment.ReservationId.ToString(),
                    ["paymentId"] = payment.Id.ToString()
                }
            },
            new RequestOptions { IdempotencyKey = $"refund-payment-{payment.Id}" });

        payment.Status = PaymentStatus.Refunded;

        dbContext.Refunds.Add(new Refund
        {
            PaymentId = payment.Id,
            StripeRefundId = stripeRefund.Id,
            Amount = StripeHelper.FromMinorUnits(stripeRefund.Amount),
            Reason = reason.Length > 500 ? reason[..500] : reason,
            CreatedAt = DateTime.UtcNow
        });
    }

    private async Task CancelOpenIntentAsync(Payment payment, string reason)
    {
        var intentService = new PaymentIntentService(stripeClient);
        var intent = await intentService.GetAsync(payment.StripePaymentIntentId);

        if (intent.Status == StripeHelper.Succeeded)
        {
            MarkSucceeded(payment, intent);
            await RefundAsync(payment, reason);
            return;
        }

        if (intent.Status != StripeHelper.Canceled)
        {
            try
            {
                await intentService.CancelAsync(payment.StripePaymentIntentId);
            }
            catch (StripeException ex)
            {
                logger.LogWarning(ex, "PaymentIntent {IntentId} nije moguće poništiti", payment.StripePaymentIntentId);
            }
        }

        payment.Status = PaymentStatus.Failed;
    }

    private static void MarkSucceeded(Payment payment, PaymentIntent intent)
    {
        payment.Status = PaymentStatus.Succeeded;
        payment.Amount = StripeHelper.FromMinorUnits(intent.AmountReceived);
        payment.PaidAt = DateTime.UtcNow;
    }
}
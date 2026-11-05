using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Stripe;
using VisitDreznica.Model.Enums;
using VisitDreznica.Model.Exceptions;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Services.Database;
using VisitDreznica.Services.Reservations;
using VisitDreznica.Services.Security;
using Payment = VisitDreznica.Services.Database.Entities.Payment;

namespace VisitDreznica.Services.Payments;

public class PaymentService(
    VisitDreznicaDbContext dbContext,
    ICurrentUser currentUser,
    IStripeClient stripeClient,
    PaymentSettings settings,
    ILogger<PaymentService> logger) : IPaymentService
{
    private const string StripeSucceeded = "succeeded";
    private static readonly string[] StripeOpenStatuses = ["requires_payment_method", "requires_confirmation", "requires_action"];

    public async Task<PaymentIntentResponse> CreateIntentAsync(PaymentIntentRequest request)
    {
        var userId = currentUser.UserId;

        var reservation = await dbContext.Reservations
                              .Include(x => x.Payments)
                              .FirstOrDefaultAsync(x => x.Id == request.ReservationId && x.UserId == userId)
                          ?? throw new NotFoundException("Tražena rezervacija ne postoji.");

        if (!ReservationRules.ActiveStatuses.Contains(reservation.Status))
        {
            throw new BusinessException("Rezervaciju s ovim statusom nije moguće platiti.");
        }

        if (reservation.Payments.Any(x => x.Status == PaymentStatus.Succeeded))
        {
            throw new BusinessException("Rezervacija je već plaćena.");
        }

        var intentService = new PaymentIntentService(stripeClient);
        var openPayment = reservation.Payments.FirstOrDefault(x => x.Status == PaymentStatus.Pending);

        if (openPayment is not null)
        {
            var existingIntent = await intentService.GetAsync(openPayment.StripePaymentIntentId);

            if (existingIntent.Status == StripeSucceeded)
            {
                MarkSucceeded(openPayment, existingIntent);
                await dbContext.SaveChangesAsync();
                throw new BusinessException("Rezervacija je već plaćena.");
            }

            if (StripeOpenStatuses.Contains(existingIntent.Status))
            {
                return ToIntentResponse(openPayment, existingIntent.ClientSecret);
            }

            openPayment.Status = PaymentStatus.Failed;
        }

        var intent = await intentService.CreateAsync(new PaymentIntentCreateOptions
        {
            Amount = ToMinorUnits(reservation.TotalPrice),
            Currency = settings.Currency,
            AutomaticPaymentMethods = new PaymentIntentAutomaticPaymentMethodsOptions { Enabled = true },
            Metadata = new Dictionary<string, string>
            {
                ["reservationId"] = reservation.Id.ToString(),
                ["userId"] = userId.ToString()
            }
        });

        var payment = new Payment
        {
            ReservationId = reservation.Id,
            StripePaymentIntentId = intent.Id,
            Amount = reservation.TotalPrice,
            Currency = settings.Currency,
            Status = PaymentStatus.Pending,
            CreatedAt = DateTime.UtcNow
        };

        dbContext.Payments.Add(payment);
        await dbContext.SaveChangesAsync();

        return ToIntentResponse(payment, intent.ClientSecret);
    }

    public async Task<PaymentResponse> ConfirmAsync(PaymentConfirmRequest request)
    {
        var userId = currentUser.UserId;

        var payment = await dbContext.Payments
                          .FirstOrDefaultAsync(x => x.StripePaymentIntentId == request.PaymentIntentId &&
                                                    x.Reservation.UserId == userId)
                      ?? throw new NotFoundException("Traženo plaćanje ne postoji.");

        if (payment.Status == PaymentStatus.Succeeded)
        {
            return ToResponse(payment);
        }

        var intent = await new PaymentIntentService(stripeClient).GetAsync(payment.StripePaymentIntentId);

        if (intent.Status != StripeSucceeded)
        {
            throw new BusinessException("Plaćanje nije završeno. Pokušajte ponovo.");
        }

        if (intent.AmountReceived != ToMinorUnits(payment.Amount))
        {
            logger.LogError("Iznos uplate {Received} ne odgovara očekivanom {Expected} za plaćanje {PaymentId}",
                intent.AmountReceived, ToMinorUnits(payment.Amount), payment.Id);
            throw new BusinessException("Iznos uplate ne odgovara iznosu rezervacije. Obratite se administratoru.");
        }

        MarkSucceeded(payment, intent);
        await dbContext.SaveChangesAsync();

        return ToResponse(payment);
    }

    private static void MarkSucceeded(Payment payment, PaymentIntent intent)
    {
        payment.Status = PaymentStatus.Succeeded;
        payment.Amount = FromMinorUnits(intent.AmountReceived);
        payment.PaidAt = DateTime.UtcNow;
    }

    private PaymentIntentResponse ToIntentResponse(Payment payment, string clientSecret) => new()
    {
        PaymentId = payment.Id,
        PaymentIntentId = payment.StripePaymentIntentId,
        ClientSecret = clientSecret,
        Amount = payment.Amount,
        Currency = payment.Currency,
        PublishableKey = settings.PublishableKey
    };

    private static PaymentResponse ToResponse(Payment payment) => new()
    {
        Id = payment.Id,
        ReservationId = payment.ReservationId,
        Amount = payment.Amount,
        Currency = payment.Currency,
        Status = payment.Status,
        CreatedAt = payment.CreatedAt,
        PaidAt = payment.PaidAt
    };

    private static long ToMinorUnits(decimal amount) => (long)Math.Round(amount * 100, MidpointRounding.AwayFromZero);

    private static decimal FromMinorUnits(long amount) => amount / 100m;
}
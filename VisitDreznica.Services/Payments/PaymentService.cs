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
    IReservationPaymentService reservationPaymentService,
    PaymentSettings settings,
    ILogger<PaymentService> logger) : IPaymentService
{
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

        if (reservation.Status == ReservationStatus.Pending &&
            reservation.CreatedAt.AddMinutes(settings.UnpaidReservationExpiryMinutes) <= DateTime.UtcNow)
        {
            throw new BusinessException("Vrijeme za plaćanje ove rezervacije je isteklo. Napravite novu rezervaciju.");
        }

        var intentService = new PaymentIntentService(stripeClient);
        var openPayment = reservation.Payments.FirstOrDefault(x => x.Status == PaymentStatus.Pending);

        if (openPayment is not null)
        {
            var existingIntent = await intentService.GetAsync(openPayment.StripePaymentIntentId);

            if (existingIntent.Status == StripeHelper.Succeeded)
            {
                MarkSucceeded(openPayment, existingIntent);
                await dbContext.SaveChangesAsync();
                throw new BusinessException("Rezervacija je već plaćena.");
            }

            if (StripeHelper.OpenStatuses.Contains(existingIntent.Status))
            {
                return ToIntentResponse(openPayment, existingIntent.ClientSecret);
            }

            openPayment.Status = PaymentStatus.Failed;
        }

        var intent = await intentService.CreateAsync(new PaymentIntentCreateOptions
        {
            Amount = StripeHelper.ToMinorUnits(reservation.TotalPrice),
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
                          .Include(x => x.Reservation)
                          .FirstOrDefaultAsync(x => x.StripePaymentIntentId == request.PaymentIntentId &&
                                                    x.Reservation.UserId == userId)
                      ?? throw new NotFoundException("Traženo plaćanje ne postoji.");

        if (payment.Status is PaymentStatus.Succeeded or PaymentStatus.Refunded)
        {
            return ToResponse(payment);
        }

        var intent = await new PaymentIntentService(stripeClient).GetAsync(payment.StripePaymentIntentId);

        if (intent.Status != StripeHelper.Succeeded)
        {
            throw new BusinessException("Plaćanje nije završeno. Pokušajte ponovo.");
        }

        if (intent.AmountReceived != StripeHelper.ToMinorUnits(payment.Amount))
        {
            logger.LogError("Iznos uplate {Received} ne odgovara očekivanom {Expected} za plaćanje {PaymentId}",
                intent.AmountReceived, StripeHelper.ToMinorUnits(payment.Amount), payment.Id);
            throw new BusinessException("Iznos uplate ne odgovara iznosu rezervacije. Obratite se administratoru.");
        }

        MarkSucceeded(payment, intent);

        if (!ReservationRules.ActiveStatuses.Contains(payment.Reservation.Status))
        {
            logger.LogWarning("Uplata {PaymentId} stigla za neaktivnu rezervaciju {ReservationId}; novac se vraća",
                payment.Id, payment.ReservationId);
            await reservationPaymentService.ReverseAsync(payment.ReservationId,
                "Uplata je stigla nakon što je rezervacija otkazana.");
        }

        await dbContext.SaveChangesAsync();

        return ToResponse(payment);
    }

    private static void MarkSucceeded(Payment payment, PaymentIntent intent)
    {
        payment.Status = PaymentStatus.Succeeded;
        payment.Amount = StripeHelper.FromMinorUnits(intent.AmountReceived);
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
}
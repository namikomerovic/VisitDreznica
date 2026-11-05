using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;

namespace VisitDreznica.Services.Payments;

public interface IPaymentService
{
    Task<PaymentIntentResponse> CreateIntentAsync(PaymentIntentRequest request);
    Task<PaymentResponse> ConfirmAsync(PaymentConfirmRequest request);
}
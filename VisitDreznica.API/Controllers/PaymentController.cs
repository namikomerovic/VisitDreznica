using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using VisitDreznica.Model.Constants;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Services.Payments;

namespace VisitDreznica.API.Controllers;

[ApiController]
[Route("[controller]")]
[Authorize(Roles = AppRoles.Guest)]
public class PaymentsController(IPaymentService paymentService) : ControllerBase
{
    [HttpPost("intent")]
    public Task<PaymentIntentResponse> CreateIntent([FromBody] PaymentIntentRequest request) =>
        paymentService.CreateIntentAsync(request);

    [HttpPost("confirm")]
    public Task<PaymentResponse> Confirm([FromBody] PaymentConfirmRequest request) =>
        paymentService.ConfirmAsync(request);
}
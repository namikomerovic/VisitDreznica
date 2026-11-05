using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using VisitDreznica.Model.Constants;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Services.Reservations;

namespace VisitDreznica.API.Controllers;

[ApiController]
[Route("[controller]")]
[Authorize]
public class EquipmentReservationsController(IEquipmentReservationService service) : ControllerBase
{
    [HttpGet("quote")]
    public Task<EquipmentReservationQuoteResponse> Quote([FromQuery] EquipmentReservationRequest request) =>
        service.QuoteAsync(request);

    [HttpPost]
    [Authorize(Roles = AppRoles.Guest)]
    public Task<ReservationResponse> Create([FromBody] EquipmentReservationRequest request) => service.CreateAsync(request);
}
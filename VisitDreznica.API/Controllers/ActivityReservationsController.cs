using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using VisitDreznica.Model.Constants;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Services.Reservations;

namespace VisitDreznica.API.Controllers;

[ApiController]
[Route("[controller]")]
[Authorize(Roles = AppRoles.Guest)]
public class ActivityReservationsController(IActivityReservationService service) : ControllerBase
{
    [HttpPost]
    public Task<ReservationResponse> Create([FromBody] ActivityReservationRequest request) => service.CreateAsync(request);
}
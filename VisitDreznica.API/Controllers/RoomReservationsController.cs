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
public class RoomReservationsController(IRoomReservationService service) : ControllerBase
{
    [HttpGet("quote")]
    public Task<RoomReservationQuoteResponse> Quote([FromQuery] RoomReservationRequest request) => service.QuoteAsync(request);

    [HttpGet("occupancy")]
    public Task<List<DateRangeResponse>> Occupancy([FromQuery] int roomId, [FromQuery] DateOnly from, [FromQuery] DateOnly to) =>
        service.GetOccupiedPeriodsAsync(roomId, from, to);

    [HttpPost]
    [Authorize(Roles = AppRoles.Guest)]
    public Task<ReservationResponse> Create([FromBody] RoomReservationRequest request) => service.CreateAsync(request);
}
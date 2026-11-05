using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using VisitDreznica.API.Controllers.Base;
using VisitDreznica.Model.Constants;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Reservations;

namespace VisitDreznica.API.Controllers;

public class ReservationsController : BaseReadController<ReservationResponse, ReservationSearchObject>
{
    private readonly IReservationService _reservationService;

    public ReservationsController(IReservationService reservationService) : base(reservationService)
    {
        _reservationService = reservationService;
    }

    [HttpPost("{id:int}/confirm")]
    [Authorize(Roles = AppRoles.Admin)]
    public Task<ReservationResponse> Confirm(int id, [FromBody] ReservationStatusChangeRequest request) =>
        _reservationService.ConfirmAsync(id, request);

    [HttpPost("{id:int}/reject")]
    [Authorize(Roles = AppRoles.Admin)]
    public Task<ReservationResponse> Reject(int id, [FromBody] ReservationStatusChangeRequest request) =>
        _reservationService.RejectAsync(id, request);

    [HttpPost("{id:int}/complete")]
    [Authorize(Roles = AppRoles.Admin)]
    public Task<ReservationResponse> Complete(int id, [FromBody] ReservationStatusChangeRequest request) =>
        _reservationService.CompleteAsync(id, request);

    [HttpPost("{id:int}/cancel")]
    public Task<ReservationResponse> Cancel(int id, [FromBody] ReservationStatusChangeRequest request) =>
        _reservationService.CancelAsync(id, request);
}
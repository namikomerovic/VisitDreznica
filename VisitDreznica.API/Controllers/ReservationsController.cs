using VisitDreznica.API.Controllers.Base;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Reservations;

namespace VisitDreznica.API.Controllers;

public class ReservationsController(IReservationService service)
    : BaseReadController<ReservationResponse, ReservationSearchObject>(service);
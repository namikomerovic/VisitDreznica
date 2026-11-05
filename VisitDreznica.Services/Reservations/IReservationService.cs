using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Base;

namespace VisitDreznica.Services.Reservations;

public interface IReservationService : IReadService<ReservationResponse, ReservationSearchObject>;
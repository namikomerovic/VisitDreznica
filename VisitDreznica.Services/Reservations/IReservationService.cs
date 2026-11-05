using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Base;

namespace VisitDreznica.Services.Reservations;

public interface IReservationService : IReadService<ReservationResponse, ReservationSearchObject>
{
    Task<ReservationResponse> ConfirmAsync(int id, ReservationStatusChangeRequest request);
    Task<ReservationResponse> RejectAsync(int id, ReservationStatusChangeRequest request);
    Task<ReservationResponse> CancelAsync(int id, ReservationStatusChangeRequest request);
    Task<ReservationResponse> CompleteAsync(int id, ReservationStatusChangeRequest request);
}
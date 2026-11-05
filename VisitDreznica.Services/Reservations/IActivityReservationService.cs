using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;

namespace VisitDreznica.Services.Reservations;

public interface IActivityReservationService
{
    Task<ReservationResponse> CreateAsync(ActivityReservationRequest request);
}
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;

namespace VisitDreznica.Services.Reservations;

public interface IRoomReservationService
{
    Task<RoomReservationQuoteResponse> QuoteAsync(RoomReservationRequest request);
    Task<ReservationResponse> CreateAsync(RoomReservationRequest request);
    Task<List<DateRangeResponse>> GetOccupiedPeriodsAsync(int roomId, DateOnly from, DateOnly to);
}
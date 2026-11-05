using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;

namespace VisitDreznica.Services.Reservations;

public interface IEquipmentReservationService
{
    Task<EquipmentReservationQuoteResponse> QuoteAsync(EquipmentReservationRequest request);
    Task<ReservationResponse> CreateAsync(EquipmentReservationRequest request);
}
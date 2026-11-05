namespace VisitDreznica.Model.Responses;

public class RoomReservationQuoteResponse
{
    public int Nights { get; set; }
    public decimal PricePerNight { get; set; }
    public decimal AccommodationPrice { get; set; }
    public decimal TouristTax { get; set; }
    public decimal TotalPrice { get; set; }
}
namespace VisitDreznica.Model.Responses;

public class EquipmentReservationQuoteResponse
{
    public int Hours { get; set; }
    public decimal UnitPrice { get; set; }
    public int Quantity { get; set; }
    public decimal TotalPrice { get; set; }
    public int AvailableQuantity { get; set; }
    public bool IsAvailable { get; set; }
}
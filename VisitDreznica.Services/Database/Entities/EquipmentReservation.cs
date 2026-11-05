namespace VisitDreznica.Services.Database.Entities;

public class EquipmentReservation : Reservation
{
    public int Quantity { get; set; }

    public int EquipmentId { get; set; }
    public Equipment Equipment { get; set; } = null!;
}
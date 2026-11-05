namespace VisitDreznica.Services.Database.Entities;

public class RoomReservation : Reservation
{
    public int GuestCount { get; set; }

    public int RoomId { get; set; }
    public Room Room { get; set; } = null!;
}
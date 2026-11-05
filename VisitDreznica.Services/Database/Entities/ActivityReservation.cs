namespace VisitDreznica.Services.Database.Entities;

public class ActivityReservation : Reservation
{
    public int ParticipantCount { get; set; }

    public int ActivitySlotId { get; set; }
    public ActivitySlot ActivitySlot { get; set; } = null!;
}
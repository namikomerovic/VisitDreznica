namespace VisitDreznica.Services.Database.Entities;

public class ContentView : IEntity, IUserItemInteraction
{
    public int Id { get; set; }
    public DateTime ViewedAt { get; set; }

    public int UserId { get; set; }
    public User User { get; set; } = null!;

    public int? RoomId { get; set; }
    public Room? Room { get; set; }

    public int? EquipmentId { get; set; }
    public Equipment? Equipment { get; set; }

    public int? ActivityId { get; set; }
    public Activity? Activity { get; set; }

    public int? PlaceId { get; set; }
    public Place? Place { get; set; }
}
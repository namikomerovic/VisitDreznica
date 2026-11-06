namespace VisitDreznica.Services.Database.Entities;

public class Review : IEntity, IUserItemInteraction
{
    public int Id { get; set; }
    public int Rating { get; set; }
    public string? Comment { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }

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
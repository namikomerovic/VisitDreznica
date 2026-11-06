namespace VisitDreznica.Services.Database.Entities;

public interface IUserItemInteraction
{
    int UserId { get; set; }

    int? RoomId { get; set; }
    Room? Room { get; set; }

    int? EquipmentId { get; set; }
    Equipment? Equipment { get; set; }

    int? ActivityId { get; set; }
    Activity? Activity { get; set; }

    int? PlaceId { get; set; }
    Place? Place { get; set; }
}
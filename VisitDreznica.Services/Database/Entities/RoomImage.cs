namespace VisitDreznica.Services.Database.Entities;

public class RoomImage : GalleryImage
{
    public Room Room { get; set; } = null!;
}
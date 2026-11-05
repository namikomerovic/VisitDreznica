namespace VisitDreznica.Services.Database.Entities;

public class PlaceImage : GalleryImage
{
    public Place Place { get; set; } = null!;
}
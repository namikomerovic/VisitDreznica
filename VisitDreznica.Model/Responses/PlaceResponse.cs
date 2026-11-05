namespace VisitDreznica.Model.Responses;

public class PlaceResponse
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public int PlaceTypeId { get; set; }
    public string PlaceTypeName { get; set; } = string.Empty;
    public decimal Latitude { get; set; }
    public decimal Longitude { get; set; }
    public string? Address { get; set; }
    public decimal DistanceKm { get; set; }
    public bool IsActive { get; set; }
    public int? CoverImageId { get; set; }
    public List<GalleryImageResponse> Images { get; set; } = [];
}
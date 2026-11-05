namespace VisitDreznica.Model.Responses;

public class RoomResponse
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public int RoomTypeId { get; set; }
    public string RoomTypeName { get; set; } = string.Empty;
    public int Capacity { get; set; }
    public int AreaSquareMeters { get; set; }
    public decimal PricePerNight { get; set; }
    public bool IsActive { get; set; }
    public int? CoverImageId { get; set; }
    public List<LookupResponse> Amenities { get; set; } = [];
    public List<GalleryImageResponse> Images { get; set; } = [];
}
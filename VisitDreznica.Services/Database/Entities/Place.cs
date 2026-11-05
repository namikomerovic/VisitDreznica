namespace VisitDreznica.Services.Database.Entities;

public class Place : IEntity
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public decimal Latitude { get; set; }
    public decimal Longitude { get; set; }
    public string? Address { get; set; }
    public decimal DistanceKm { get; set; }
    public bool IsActive { get; set; } = true;
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }

    public int PlaceTypeId { get; set; }
    public PlaceType PlaceType { get; set; } = null!;

    public ICollection<PlaceImage> Images { get; set; } = new List<PlaceImage>();
}
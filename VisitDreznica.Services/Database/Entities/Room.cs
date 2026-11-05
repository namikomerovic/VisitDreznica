namespace VisitDreznica.Services.Database.Entities;

public class Room : IEntity
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public int Capacity { get; set; }
    public int AreaSquareMeters { get; set; }
    public decimal PricePerNight { get; set; }
    public bool IsActive { get; set; } = true;
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }

    public int RoomTypeId { get; set; }
    public RoomType RoomType { get; set; } = null!;

    public ICollection<RoomImage> Images { get; set; } = new List<RoomImage>();
    public ICollection<RoomAmenity> RoomAmenities { get; set; } = new List<RoomAmenity>();
}
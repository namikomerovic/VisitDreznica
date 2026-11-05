namespace VisitDreznica.Services.Database.Entities;

public class RoomImage : IEntity
{
    public int Id { get; set; }
    public byte[] Data { get; set; } = [];
    public string ContentType { get; set; } = string.Empty;
    public bool IsCover { get; set; }
    public int DisplayOrder { get; set; }
    public DateTime CreatedAt { get; set; }

    public int RoomId { get; set; }
    public Room Room { get; set; } = null!;
}
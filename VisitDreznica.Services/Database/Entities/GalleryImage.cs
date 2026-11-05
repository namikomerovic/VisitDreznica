namespace VisitDreznica.Services.Database.Entities;

public abstract class GalleryImage : IEntity
{
    public int Id { get; set; }
    public int OwnerId { get; set; }
    public byte[] Data { get; set; } = [];
    public string ContentType { get; set; } = string.Empty;
    public bool IsCover { get; set; }
    public int DisplayOrder { get; set; }
    public DateTime CreatedAt { get; set; }
}
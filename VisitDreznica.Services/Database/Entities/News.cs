namespace VisitDreznica.Services.Database.Entities;

public class News : IHasImage
{
    public int Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Content { get; set; } = string.Empty;
    public DateTime PublishedAt { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }

    public byte[]? ImageData { get; set; }
    public string? ImageContentType { get; set; }

    public int CreatedByUserId { get; set; }
    public User CreatedByUser { get; set; } = null!;
}
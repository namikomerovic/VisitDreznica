namespace VisitDreznica.Model.Responses;

public class NewsResponse
{
    public int Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Content { get; set; } = string.Empty;
    public DateTime PublishedAt { get; set; }
    public bool HasImage { get; set; }
    public bool IsPublished { get; set; }
    public string CreatedByFullName { get; set; } = string.Empty;
}
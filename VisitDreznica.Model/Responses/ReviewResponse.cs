using VisitDreznica.Model.Enums;

namespace VisitDreznica.Model.Responses;

public class ReviewResponse
{
    public int Id { get; set; }
    public ItemType ItemType { get; set; }
    public int ItemId { get; set; }
    public string ItemName { get; set; } = string.Empty;
    public int Rating { get; set; }
    public string? Comment { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public int UserId { get; set; }
    public string UserFullName { get; set; } = string.Empty;
}
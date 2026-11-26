using VisitDreznica.Model.Enums;

namespace VisitDreznica.Model.Responses;

public class FavoriteResponse
{
    public int Id { get; set; }
    public ItemType ItemType { get; set; }
    public int ItemId { get; set; }
    public string ItemName { get; set; } = string.Empty;
    public int? CoverImageId { get; set; }
    public bool HasImage { get; set; }
    public DateTime CreatedAt { get; set; }
}
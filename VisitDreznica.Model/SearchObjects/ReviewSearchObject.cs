using VisitDreznica.Model.Enums;

namespace VisitDreznica.Model.SearchObjects;

public class ReviewSearchObject : BaseSearchObject
{
    public ItemType? ItemType { get; set; }
    public int? ItemId { get; set; }
    public int? UserId { get; set; }
    public int? MinRating { get; set; }
    public bool OnlyMine { get; set; }
    public int? MaxRating { get; set; }
}
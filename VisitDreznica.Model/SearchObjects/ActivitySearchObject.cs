namespace VisitDreznica.Model.SearchObjects;

public class ActivitySearchObject : BaseSearchObject
{
    public string? Name { get; set; }
    public int? ActivityCategoryId { get; set; }
    public bool? IsActive { get; set; }
}
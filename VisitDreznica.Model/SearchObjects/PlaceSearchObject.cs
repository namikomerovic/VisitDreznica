namespace VisitDreznica.Model.SearchObjects;

public class PlaceSearchObject : BaseSearchObject
{
    public string? Name { get; set; }
    public int? PlaceTypeId { get; set; }
    public bool? IsActive { get; set; }
}
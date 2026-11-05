namespace VisitDreznica.Model.SearchObjects;

public class UserSearchObject : BaseSearchObject
{
    public string? Text { get; set; }
    public int? CityId { get; set; }
    public int? RoleId { get; set; }
    public bool? IsActive { get; set; }
}
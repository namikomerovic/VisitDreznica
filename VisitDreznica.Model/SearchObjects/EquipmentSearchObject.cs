namespace VisitDreznica.Model.SearchObjects;

public class EquipmentSearchObject : BaseSearchObject
{
    public string? Name { get; set; }
    public int? EquipmentTypeId { get; set; }
    public bool? IsActive { get; set; }
}
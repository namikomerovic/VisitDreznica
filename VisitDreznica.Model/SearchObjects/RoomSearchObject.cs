namespace VisitDreznica.Model.SearchObjects;

public class RoomSearchObject : BaseSearchObject
{
    public string? Name { get; set; }
    public int? RoomTypeId { get; set; }
    public int? MinCapacity { get; set; }
    public decimal? MaxPrice { get; set; }
    public bool? IsActive { get; set; }
}
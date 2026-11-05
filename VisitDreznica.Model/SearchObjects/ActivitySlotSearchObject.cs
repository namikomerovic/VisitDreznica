namespace VisitDreznica.Model.SearchObjects;

public class ActivitySlotSearchObject : BaseSearchObject
{
    public int? ActivityId { get; set; }
    public int? GuideId { get; set; }
    public DateTime? From { get; set; }
    public DateTime? To { get; set; }
    public bool OnlyUpcoming { get; set; }
}
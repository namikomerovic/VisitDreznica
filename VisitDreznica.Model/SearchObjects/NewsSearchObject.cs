namespace VisitDreznica.Model.SearchObjects;

public class NewsSearchObject : BaseSearchObject
{
    public string? Title { get; set; }
    public DateTime? From { get; set; }
    public DateTime? To { get; set; }
}
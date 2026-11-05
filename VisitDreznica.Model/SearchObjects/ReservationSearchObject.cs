using VisitDreznica.Model.Enums;

namespace VisitDreznica.Model.SearchObjects;

public class ReservationSearchObject : BaseSearchObject
{
    public ReservationType? Type { get; set; }
    public List<ReservationStatus>? Statuses { get; set; }
    public DateTime? From { get; set; }
    public DateTime? To { get; set; }
    public int? UserId { get; set; }
    public string? GuestName { get; set; }
    public bool OrderByStartTime { get; set; }
}
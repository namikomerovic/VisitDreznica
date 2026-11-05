using VisitDreznica.Model.Enums;

namespace VisitDreznica.Model.Responses;

public class ReservationStatusHistoryResponse
{
    public ReservationStatus? FromStatus { get; set; }
    public ReservationStatus ToStatus { get; set; }
    public DateTime ChangedAt { get; set; }
    public string ChangedByFullName { get; set; } = string.Empty;
    public string? Comment { get; set; }
}
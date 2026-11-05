using VisitDreznica.Model.Enums;

namespace VisitDreznica.Model.Responses;

public class ReservationResponse
{
    public int Id { get; set; }
    public ReservationType Type { get; set; }
    public ReservationStatus Status { get; set; }
    public DateTime StartTime { get; set; }
    public DateTime EndTime { get; set; }
    public decimal TotalPrice { get; set; }
    public string? Note { get; set; }
    public DateTime CreatedAt { get; set; }

    public int UserId { get; set; }
    public string UserFullName { get; set; } = string.Empty;

    public string ItemName { get; set; } = string.Empty;

    public int? RoomId { get; set; }
    public int? GuestCount { get; set; }

    public int? EquipmentId { get; set; }
    public int? Quantity { get; set; }

    public int? ActivityId { get; set; }
    public int? ActivitySlotId { get; set; }
    public int? ParticipantCount { get; set; }

    public List<ReservationStatusHistoryResponse>? StatusHistory { get; set; }
}
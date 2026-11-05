using System.ComponentModel.DataAnnotations;

namespace VisitDreznica.Model.Requests;

public class ReservationStatusChangeRequest
{
    [StringLength(500, ErrorMessage = "Komentar može imati najviše 500 znakova.")]
    public string? Comment { get; set; }
}
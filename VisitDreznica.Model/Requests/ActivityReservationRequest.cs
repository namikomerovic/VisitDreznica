using System.ComponentModel.DataAnnotations;

namespace VisitDreznica.Model.Requests;

public class ActivityReservationRequest
{
    [Range(1, int.MaxValue, ErrorMessage = "Odaberite termin.")]
    public int ActivitySlotId { get; set; }

    [Range(1, 50, ErrorMessage = "Broj osoba mora biti između 1 i 50.")]
    public int ParticipantCount { get; set; }

    [StringLength(500, ErrorMessage = "Napomena može imati najviše 500 znakova.")]
    public string? Note { get; set; }
}
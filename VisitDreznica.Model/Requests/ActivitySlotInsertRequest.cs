using System.ComponentModel.DataAnnotations;

namespace VisitDreznica.Model.Requests;

public class ActivitySlotInsertRequest
{
    [Range(1, int.MaxValue, ErrorMessage = "Odaberite aktivnost.")]
    public int ActivityId { get; set; }

    [Required(ErrorMessage = "Početak termina je obavezan.")]
    public DateTime StartTime { get; set; }

    [Range(1, 50, ErrorMessage = "Kapacitet termina mora biti između 1 i 50 osoba.")]
    public int Capacity { get; set; }

    [Range(1, int.MaxValue, ErrorMessage = "Odaberite vodiča.")]
    public int GuideId { get; set; }
}
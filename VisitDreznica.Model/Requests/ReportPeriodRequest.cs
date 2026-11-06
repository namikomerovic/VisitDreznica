using System.ComponentModel.DataAnnotations;

namespace VisitDreznica.Model.Requests;

public class ReportPeriodRequest
{
    [Required(ErrorMessage = "Odaberite početni datum.")]
    public DateOnly? From { get; set; }

    [Required(ErrorMessage = "Odaberite krajnji datum.")]
    public DateOnly? To { get; set; }
}
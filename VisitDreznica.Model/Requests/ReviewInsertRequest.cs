using System.ComponentModel.DataAnnotations;

namespace VisitDreznica.Model.Requests;

public class ReviewInsertRequest : ItemReferenceRequest
{
    [Range(1, 5, ErrorMessage = "Ocjena mora biti između 1 i 5.")]
    public int Rating { get; set; }

    [StringLength(1000, ErrorMessage = "Komentar može imati najviše 1000 znakova.")]
    public string? Comment { get; set; }
}
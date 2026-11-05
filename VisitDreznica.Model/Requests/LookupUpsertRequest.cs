using System.ComponentModel.DataAnnotations;

namespace VisitDreznica.Model.Requests;

public class LookupUpsertRequest
{
    [Required(ErrorMessage = "Naziv je obavezan.")]
    [StringLength(100, MinimumLength = 2, ErrorMessage = "Naziv mora imati između 2 i 100 znakova.")]
    public string Name { get; set; } = string.Empty;

    [StringLength(300, ErrorMessage = "Opis može imati najviše 300 znakova.")]
    public string? Description { get; set; }
}
using System.ComponentModel.DataAnnotations;

namespace VisitDreznica.Model.Requests;

public class GuideUpsertRequest
{
    [Required(ErrorMessage = "Ime je obavezno.")]
    [StringLength(50, ErrorMessage = "Ime može imati najviše 50 znakova.")]
    public string FirstName { get; set; } = string.Empty;

    [Required(ErrorMessage = "Prezime je obavezno.")]
    [StringLength(50, ErrorMessage = "Prezime može imati najviše 50 znakova.")]
    public string LastName { get; set; } = string.Empty;

    [RegularExpression(@"^\+?[0-9 ]{6,20}$",
        ErrorMessage = "Unesite ispravan broj telefona, npr. 061 234 567 ili +387 61 234 567.")]
    public string? PhoneNumber { get; set; }
}
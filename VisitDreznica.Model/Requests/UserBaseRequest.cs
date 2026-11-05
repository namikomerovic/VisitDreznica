using System.ComponentModel.DataAnnotations;
using VisitDreznica.Model.Constants;

namespace VisitDreznica.Model.Requests;

public abstract class UserBaseRequest
{
    [Required(ErrorMessage = "Ime je obavezno.")]
    [StringLength(50, ErrorMessage = "Ime može imati najviše 50 znakova.")]
    public string FirstName { get; set; } = string.Empty;

    [Required(ErrorMessage = "Prezime je obavezno.")]
    [StringLength(50, ErrorMessage = "Prezime može imati najviše 50 znakova.")]
    public string LastName { get; set; } = string.Empty;

    [Required(ErrorMessage = "E-mail je obavezan.")]
    [EmailAddress(ErrorMessage = "Unesite ispravnu e-mail adresu, npr. ime@domena.ba.")]
    [StringLength(100, ErrorMessage = "E-mail može imati najviše 100 znakova.")]
    public string Email { get; set; } = string.Empty;

    [RegularExpression(ValidationPatterns.Phone, ErrorMessage = ValidationPatterns.PhoneMessage)]
    public string? PhoneNumber { get; set; }

    [Range(1, int.MaxValue, ErrorMessage = "Odaberite grad.")]
    public int CityId { get; set; }
}
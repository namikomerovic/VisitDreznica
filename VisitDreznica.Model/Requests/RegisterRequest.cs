using System.ComponentModel.DataAnnotations;

namespace VisitDreznica.Model.Requests;

public class RegisterRequest
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

    [Required(ErrorMessage = "Korisničko ime je obavezno.")]
    [RegularExpression(@"^[a-zA-Z0-9._]{3,50}$",
        ErrorMessage = "Korisničko ime mora imati 3–50 znakova: slova, brojevi, tačka ili donja crta.")]
    public string Username { get; set; } = string.Empty;

    [RegularExpression(@"^\+?[0-9 ]{6,20}$",
        ErrorMessage = "Unesite ispravan broj telefona, npr. 061 234 567 ili +387 61 234 567.")]
    public string? PhoneNumber { get; set; }

    [Range(1, int.MaxValue, ErrorMessage = "Odaberite grad.")]
    public int CityId { get; set; }

    [Required(ErrorMessage = "Lozinka je obavezna.")]
    [RegularExpression(@"^(?=.*[A-Za-z])(?=.*\d).{8,}$",
        ErrorMessage = "Lozinka mora imati najmanje 8 znakova, uključujući barem jedno slovo i jedan broj.")]
    public string Password { get; set; } = string.Empty;

    [Required(ErrorMessage = "Potvrda lozinke je obavezna.")]
    [Compare(nameof(Password), ErrorMessage = "Lozinke se ne podudaraju.")]
    public string PasswordConfirmation { get; set; } = string.Empty;
}
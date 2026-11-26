using System.ComponentModel.DataAnnotations;
using VisitDreznica.Model.Constants;

namespace VisitDreznica.Model.Requests;

public class PasswordResetConfirmRequest
{
    [Required(ErrorMessage = "E-mail je obavezan.")]
    [EmailAddress(ErrorMessage = "Unesite ispravnu e-mail adresu, npr. ime@primjer.com.")]
    public string Email { get; set; } = string.Empty;

    [Required(ErrorMessage = "Unesite kod iz e-maila.")]
    [RegularExpression(@"^\d{6}$", ErrorMessage = "Kod se sastoji od tačno 6 cifara.")]
    public string Code { get; set; } = string.Empty;

    [Required(ErrorMessage = "Nova lozinka je obavezna.")]
    [RegularExpression(ValidationPatterns.Password, ErrorMessage = ValidationPatterns.PasswordMessage)]
    public string NewPassword { get; set; } = string.Empty;

    [Required(ErrorMessage = "Potvrda nove lozinke je obavezna.")]
    [Compare(nameof(NewPassword), ErrorMessage = "Lozinke se ne podudaraju.")]
    public string NewPasswordConfirmation { get; set; } = string.Empty;
}

using System.ComponentModel.DataAnnotations;
using VisitDreznica.Model.Constants;

namespace VisitDreznica.Model.Requests;

public class ChangePasswordRequest
{
    [Required(ErrorMessage = "Unesite trenutnu lozinku.")]
    public string CurrentPassword { get; set; } = string.Empty;

    [Required(ErrorMessage = "Nova lozinka je obavezna.")]
    [RegularExpression(ValidationPatterns.Password, ErrorMessage = ValidationPatterns.PasswordMessage)]
    public string NewPassword { get; set; } = string.Empty;

    [Required(ErrorMessage = "Potvrda nove lozinke je obavezna.")]
    [Compare(nameof(NewPassword), ErrorMessage = "Lozinke se ne podudaraju.")]
    public string NewPasswordConfirmation { get; set; } = string.Empty;
}
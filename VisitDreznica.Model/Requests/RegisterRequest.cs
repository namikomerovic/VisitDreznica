using System.ComponentModel.DataAnnotations;
using VisitDreznica.Model.Constants;

namespace VisitDreznica.Model.Requests;

public class RegisterRequest : UserBaseRequest
{
    [Required(ErrorMessage = "Korisničko ime je obavezno.")]
    [RegularExpression(ValidationPatterns.Username, ErrorMessage = ValidationPatterns.UsernameMessage)]
    public string Username { get; set; } = string.Empty;

    [Required(ErrorMessage = "Lozinka je obavezna.")]
    [RegularExpression(ValidationPatterns.Password, ErrorMessage = ValidationPatterns.PasswordMessage)]
    public string Password { get; set; } = string.Empty;

    [Required(ErrorMessage = "Potvrda lozinke je obavezna.")]
    [Compare(nameof(Password), ErrorMessage = "Lozinke se ne podudaraju.")]
    public string PasswordConfirmation { get; set; } = string.Empty;
}
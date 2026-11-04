using System.ComponentModel.DataAnnotations;

namespace VisitDreznica.Model.Requests;

public class LoginRequest
{
    [Required(ErrorMessage = "Korisničko ime je obavezno.")]
    public string Username { get; set; } = string.Empty;

    [Required(ErrorMessage = "Lozinka je obavezna.")]
    public string Password { get; set; } = string.Empty;
}
using System.ComponentModel.DataAnnotations;
using VisitDreznica.Model.Constants;

namespace VisitDreznica.Model.Requests;

public class UserUpdateRequest : UserBaseRequest
{
    [Required(ErrorMessage = "Korisničko ime je obavezno.")]
    [RegularExpression(ValidationPatterns.Username, ErrorMessage = ValidationPatterns.UsernameMessage)]
    public string Username { get; set; } = string.Empty;

    [RegularExpression(ValidationPatterns.Password, ErrorMessage = ValidationPatterns.PasswordMessage)]
    public string? NewPassword { get; set; }

    [Compare(nameof(NewPassword), ErrorMessage = "Lozinke se ne podudaraju.")]
    public string? NewPasswordConfirmation { get; set; }

    [MinLength(1, ErrorMessage = "Odaberite barem jednu ulogu.")]
    public List<int> RoleIds { get; set; } = [];

    public bool IsActive { get; set; } = true;
}
using System.ComponentModel.DataAnnotations;

namespace VisitDreznica.Model.Requests;

public class PasswordResetRequest
{
    [Required(ErrorMessage = "E-mail je obavezan.")]
    [EmailAddress(ErrorMessage = "Unesite ispravnu e-mail adresu, npr. ime@primjer.com.")]
    public string Email { get; set; } = string.Empty;
}

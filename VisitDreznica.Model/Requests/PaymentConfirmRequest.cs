using System.ComponentModel.DataAnnotations;

namespace VisitDreznica.Model.Requests;

public class PaymentConfirmRequest
{
    [Required(ErrorMessage = "Identifikator plaćanja je obavezan.")]
    [StringLength(100, ErrorMessage = "Identifikator plaćanja nije ispravan.")]
    public string PaymentIntentId { get; set; } = string.Empty;
}
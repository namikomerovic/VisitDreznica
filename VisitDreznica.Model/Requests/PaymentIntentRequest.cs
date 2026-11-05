using System.ComponentModel.DataAnnotations;

namespace VisitDreznica.Model.Requests;

public class PaymentIntentRequest
{
    [Range(1, int.MaxValue, ErrorMessage = "Odaberite rezervaciju.")]
    public int ReservationId { get; set; }
}
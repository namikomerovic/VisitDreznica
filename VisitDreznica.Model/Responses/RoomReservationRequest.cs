using System.ComponentModel.DataAnnotations;

namespace VisitDreznica.Model.Requests;

public class RoomReservationRequest
{
    [Range(1, int.MaxValue, ErrorMessage = "Odaberite sobu.")]
    public int RoomId { get; set; }

    [Required(ErrorMessage = "Datum dolaska je obavezan.")]
    public DateOnly? CheckIn { get; set; }

    [Required(ErrorMessage = "Datum odlaska je obavezan.")]
    public DateOnly? CheckOut { get; set; }

    [Range(1, 10, ErrorMessage = "Broj gostiju mora biti između 1 i 10.")]
    public int GuestCount { get; set; }

    [StringLength(500, ErrorMessage = "Napomena može imati najviše 500 znakova.")]
    public string? Note { get; set; }
}
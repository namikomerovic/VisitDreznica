using System.ComponentModel.DataAnnotations;

namespace VisitDreznica.Model.Requests;

public class EquipmentReservationRequest
{
    [Range(1, int.MaxValue, ErrorMessage = "Odaberite opremu.")]
    public int EquipmentId { get; set; }

    [Required(ErrorMessage = "Početak najma je obavezan.")]
    public DateTime? StartTime { get; set; }

    [Required(ErrorMessage = "Kraj najma je obavezan.")]
    public DateTime? EndTime { get; set; }

    [Range(1, 20, ErrorMessage = "Broj komada mora biti između 1 i 20.")]
    public int Quantity { get; set; }

    [StringLength(500, ErrorMessage = "Napomena može imati najviše 500 znakova.")]
    public string? Note { get; set; }
}
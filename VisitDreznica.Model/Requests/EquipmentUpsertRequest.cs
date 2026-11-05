using System.ComponentModel.DataAnnotations;

namespace VisitDreznica.Model.Requests;

public class EquipmentUpsertRequest
{
    [Required(ErrorMessage = "Naziv opreme je obavezan.")]
    [StringLength(100, MinimumLength = 3, ErrorMessage = "Naziv opreme mora imati između 3 i 100 znakova.")]
    public string Name { get; set; } = string.Empty;

    [StringLength(1000, ErrorMessage = "Opis može imati najviše 1000 znakova.")]
    public string? Description { get; set; }

    [Range(1, int.MaxValue, ErrorMessage = "Odaberite tip opreme.")]
    public int EquipmentTypeId { get; set; }

    [Range(1, 4, ErrorMessage = "Kapacitet mora biti između 1 i 4 osobe po komadu.")]
    public int Capacity { get; set; }

    [Range(1, 100, ErrorMessage = "Ukupan broj komada mora biti između 1 i 100.")]
    public int TotalQuantity { get; set; }

    [Range(typeof(decimal), "1", "1000", ErrorMessage = "Cijena prvog sata mora biti između 1 i 1.000 KM, npr. 20.")]
    public decimal FirstHourPrice { get; set; }

    [Range(typeof(decimal), "1", "1000", ErrorMessage = "Cijena svakog sljedećeg sata mora biti između 1 i 1.000 KM, npr. 15.")]
    public decimal AdditionalHourPrice { get; set; }

    [Range(typeof(decimal), "1", "1000", ErrorMessage = "Cijena za cijeli dan mora biti između 1 i 1.000 KM, npr. 60.")]
    public decimal FullDayPrice { get; set; }

    public bool IsActive { get; set; } = true;
}
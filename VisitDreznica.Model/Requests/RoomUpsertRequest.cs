using System.ComponentModel.DataAnnotations;

namespace VisitDreznica.Model.Requests;

public class RoomUpsertRequest
{
    [Required(ErrorMessage = "Naziv sobe je obavezan.")]
    [StringLength(100, MinimumLength = 3, ErrorMessage = "Naziv sobe mora imati između 3 i 100 znakova.")]
    public string Name { get; set; } = string.Empty;

    [StringLength(1000, ErrorMessage = "Opis može imati najviše 1000 znakova.")]
    public string? Description { get; set; }

    [Range(1, int.MaxValue, ErrorMessage = "Odaberite tip sobe.")]
    public int RoomTypeId { get; set; }

    [Range(1, 10, ErrorMessage = "Kapacitet mora biti između 1 i 10 osoba.")]
    public int Capacity { get; set; }

    [Range(5, 200, ErrorMessage = "Površina mora biti između 5 i 200 m².")]
    public int AreaSquareMeters { get; set; }

    [Range(typeof(decimal), "1", "10000", ErrorMessage = "Cijena po noći mora biti između 1 i 10.000 KM, npr. 90 ili 90,50.")]
    public decimal PricePerNight { get; set; }

    public bool IsActive { get; set; } = true;

    public List<int> AmenityIds { get; set; } = [];
}
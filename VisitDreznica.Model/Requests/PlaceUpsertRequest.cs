using System.ComponentModel.DataAnnotations;

namespace VisitDreznica.Model.Requests;

public class PlaceUpsertRequest
{
    [Required(ErrorMessage = "Naziv mjesta je obavezan.")]
    [StringLength(150, MinimumLength = 3, ErrorMessage = "Naziv mjesta mora imati između 3 i 150 znakova.")]
    public string Name { get; set; } = string.Empty;

    [StringLength(2000, ErrorMessage = "Opis može imati najviše 2000 znakova.")]
    public string? Description { get; set; }

    [Range(1, int.MaxValue, ErrorMessage = "Odaberite tip mjesta.")]
    public int PlaceTypeId { get; set; }

    [Range(typeof(decimal), "-90", "90", ErrorMessage = "Odaberite lokaciju na karti (geografska širina mora biti između -90 i 90).")]
    public decimal Latitude { get; set; }

    [Range(typeof(decimal), "-180", "180", ErrorMessage = "Odaberite lokaciju na karti (geografska dužina mora biti između -180 i 180).")]
    public decimal Longitude { get; set; }

    [StringLength(200, ErrorMessage = "Adresa može imati najviše 200 znakova.")]
    public string? Address { get; set; }

    public bool IsActive { get; set; } = true;
}
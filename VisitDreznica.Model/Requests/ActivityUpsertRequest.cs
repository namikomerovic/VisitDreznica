using System.ComponentModel.DataAnnotations;

namespace VisitDreznica.Model.Requests;

public class ActivityUpsertRequest
{
    [Required(ErrorMessage = "Naziv aktivnosti je obavezan.")]
    [StringLength(150, MinimumLength = 3, ErrorMessage = "Naziv aktivnosti mora imati između 3 i 150 znakova.")]
    public string Name { get; set; } = string.Empty;

    [StringLength(2000, ErrorMessage = "Opis može imati najviše 2000 znakova.")]
    public string? Description { get; set; }

    [Range(1, int.MaxValue, ErrorMessage = "Odaberite kategoriju aktivnosti.")]
    public int ActivityCategoryId { get; set; }

    [Range(30, 720, ErrorMessage = "Trajanje mora biti između 30 i 720 minuta (12 sati), npr. 180.")]
    public int DurationMinutes { get; set; }

    [Range(1, 50, ErrorMessage = "Maksimalan broj učesnika mora biti između 1 i 50.")]
    public int MaxParticipants { get; set; }

    [Range(typeof(decimal), "1", "1000", ErrorMessage = "Cijena po osobi mora biti između 1 i 1.000 KM, npr. 60.")]
    public decimal PricePerPerson { get; set; }

    [StringLength(200, ErrorMessage = "Mjesto okupljanja može imati najviše 200 znakova.")]
    public string? MeetingPoint { get; set; }

    public bool IsActive { get; set; } = true;
}
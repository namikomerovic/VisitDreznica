using System.ComponentModel.DataAnnotations;

namespace VisitDreznica.Model.Requests;

public class NewsUpsertRequest
{
    [Required(ErrorMessage = "Naslov je obavezan.")]
    [StringLength(150, MinimumLength = 3, ErrorMessage = "Naslov mora imati između 3 i 150 znakova.")]
    public string Title { get; set; } = string.Empty;

    [Required(ErrorMessage = "Tekst obavijesti je obavezan.")]
    [StringLength(4000, MinimumLength = 10, ErrorMessage = "Tekst obavijesti mora imati između 10 i 4000 znakova.")]
    public string Content { get; set; } = string.Empty;

    [Required(ErrorMessage = "Datum i vrijeme objave su obavezni.")]
    public DateTime PublishedAt { get; set; }
}
using System;
using System.Collections.Generic;
using System.Text;

using System.ComponentModel.DataAnnotations;

namespace VisitDreznica.Model.Requests;

public class CityUpsertRequest
{
    [Required(ErrorMessage = "Naziv grada je obavezan.")]
    [StringLength(100, MinimumLength = 2, ErrorMessage = "Naziv grada mora imati između 2 i 100 znakova.")]
    public string Name { get; set; } = string.Empty;

    [RegularExpression(@"^\d{4,6}$", ErrorMessage = "Poštanski broj mora imati 4 do 6 cifara, npr. 88000.")]
    public string? PostalCode { get; set; }

    [Range(1, int.MaxValue, ErrorMessage = "Odaberite državu.")]
    public int CountryId { get; set; }
}

using System;
using System.Collections.Generic;
using System.Text;

using System.ComponentModel.DataAnnotations;

namespace VisitDreznica.Model.Requests;

public class CountryUpsertRequest
{
    [Required(ErrorMessage = "Naziv države je obavezan.")]
    [StringLength(100, MinimumLength = 2, ErrorMessage = "Naziv države mora imati između 2 i 100 znakova.")]
    public string Name { get; set; } = string.Empty;
}

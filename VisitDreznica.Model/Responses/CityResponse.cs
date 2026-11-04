using System;
using System.Collections.Generic;
using System.Text;

namespace VisitDreznica.Model.Responses;

public class CityResponse
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? PostalCode { get; set; }
    public int CountryId { get; set; }
    public string CountryName { get; set; } = string.Empty;
}

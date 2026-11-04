using System;
using System.Collections.Generic;
using System.Text;

namespace VisitDreznica.Model.SearchObjects;

public class CitySearchObject : BaseSearchObject
{
    public string? Name { get; set; }
    public int? CountryId { get; set; }
}

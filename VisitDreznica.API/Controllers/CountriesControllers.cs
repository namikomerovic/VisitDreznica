using VisitDreznica.API.Controllers.Base;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Locations;

namespace VisitDreznica.API.Controllers;

public class CountriesController(ICountryService service)
    : BaseCrudController<CountryResponse, CountrySearchObject, CountryUpsertRequest, CountryUpsertRequest>(service)
{
}
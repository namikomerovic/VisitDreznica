using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Base;

namespace VisitDreznica.Services.Locations;

public interface ICountryService
    : ICrudService<CountryResponse, CountrySearchObject, CountryUpsertRequest, CountryUpsertRequest>;

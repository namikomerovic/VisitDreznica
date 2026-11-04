using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Base;

namespace VisitDreznica.Services.Locations;

public interface ICityService
    : ICrudService<CityResponse, CitySearchObject, CityUpsertRequest, CityUpsertRequest>;
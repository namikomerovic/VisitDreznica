using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Base;

namespace VisitDreznica.Services.Places;

public interface IPlaceService : ICrudService<PlaceResponse, PlaceSearchObject, PlaceUpsertRequest, PlaceUpsertRequest>;
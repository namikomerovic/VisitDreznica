using VisitDreznica.API.Controllers.Base;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Database.Entities;
using VisitDreznica.Services.Lookups;

namespace VisitDreznica.API.Controllers;

public class RoomTypesController(ILookupService<RoomType> service)
    : BaseCrudController<LookupResponse, LookupSearchObject, LookupUpsertRequest, LookupUpsertRequest>(service);

public class AmenitiesController(ILookupService<Amenity> service)
    : BaseCrudController<LookupResponse, LookupSearchObject, LookupUpsertRequest, LookupUpsertRequest>(service);

public class EquipmentTypesController(ILookupService<EquipmentType> service)
    : BaseCrudController<LookupResponse, LookupSearchObject, LookupUpsertRequest, LookupUpsertRequest>(service);

public class ActivityCategoriesController(ILookupService<ActivityCategory> service)
    : BaseCrudController<LookupResponse, LookupSearchObject, LookupUpsertRequest, LookupUpsertRequest>(service);

public class PlaceTypesController(ILookupService<PlaceType> service)
    : BaseCrudController<LookupResponse, LookupSearchObject, LookupUpsertRequest, LookupUpsertRequest>(service);
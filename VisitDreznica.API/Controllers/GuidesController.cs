using VisitDreznica.API.Controllers.Base;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Lookups;

namespace VisitDreznica.API.Controllers;

public class GuidesController(IGuideService service)
    : BaseCrudController<GuideResponse, GuideSearchObject, GuideUpsertRequest, GuideUpsertRequest>(service);
using VisitDreznica.API.Controllers.Base;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Activities;

namespace VisitDreznica.API.Controllers;

public class ActivitySlotsController(IActivitySlotService service)
    : BaseCrudController<ActivitySlotResponse, ActivitySlotSearchObject, ActivitySlotInsertRequest, ActivitySlotUpdateRequest>(service);
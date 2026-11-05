using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Base;

namespace VisitDreznica.Services.Activities;

public interface IActivityService
    : ICrudService<ActivityResponse, ActivitySearchObject, ActivityUpsertRequest, ActivityUpsertRequest>;
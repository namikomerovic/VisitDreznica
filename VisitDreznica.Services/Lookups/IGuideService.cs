using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Base;

namespace VisitDreznica.Services.Lookups;

public interface IGuideService
    : ICrudService<GuideResponse, GuideSearchObject, GuideUpsertRequest, GuideUpsertRequest>;
using VisitDreznica.API.Controllers.Base;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Activities;
using VisitDreznica.Services.Database.Entities;
using VisitDreznica.Services.Images;

namespace VisitDreznica.API.Controllers;

public class ActivitiesController(IActivityService service, IEntityImageService<Activity> imageService)
    : ImageCrudController<Activity, ActivityResponse, ActivitySearchObject, ActivityUpsertRequest, ActivityUpsertRequest>(service, imageService);
using Microsoft.AspNetCore.Authorization;
using VisitDreznica.API.Controllers.Base;
using VisitDreznica.Model.Constants;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Database.Entities;
using VisitDreznica.Services.Lookups;

namespace VisitDreznica.API.Controllers;

[Authorize(Roles = AppRoles.Admin)]
public class RolesController(ILookupService<Role> service)
    : BaseReadController<LookupResponse, LookupSearchObject>(service);
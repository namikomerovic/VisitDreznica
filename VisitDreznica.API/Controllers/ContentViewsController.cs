using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using VisitDreznica.Model.Constants;
using VisitDreznica.Model.Requests;
using VisitDreznica.Services.Interactions;

namespace VisitDreznica.API.Controllers;

[ApiController]
[Route("[controller]")]
[Authorize(Roles = AppRoles.Guest)]
public class ContentViewsController(IContentViewService contentViewService) : ControllerBase
{
    [HttpPost]
    public async Task<IActionResult> Record([FromBody] ItemReferenceRequest item)
    {
        await contentViewService.RecordAsync(item);
        return NoContent();
    }
}
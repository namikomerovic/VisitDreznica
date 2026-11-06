using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using VisitDreznica.Model.Constants;
using VisitDreznica.Model.Enums;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Services.Interactions;

namespace VisitDreznica.API.Controllers;

[ApiController]
[Route("[controller]")]
[Authorize(Roles = AppRoles.Guest)]
public class FavoritesController(IFavoriteService favoriteService) : ControllerBase
{
    [HttpGet]
    public Task<List<FavoriteResponse>> Get([FromQuery] ItemType? itemType) =>
        favoriteService.GetMineAsync(itemType);

    [HttpPost]
    public Task<FavoriteResponse> Add([FromBody] ItemReferenceRequest item) =>
        favoriteService.AddAsync(item);

    [HttpDelete]
    public async Task<IActionResult> Remove([FromQuery] ItemReferenceRequest item)
    {
        await favoriteService.RemoveAsync(item);
        return NoContent();
    }
}
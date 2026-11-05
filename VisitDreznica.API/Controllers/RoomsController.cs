using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using VisitDreznica.API.Controllers.Base;
using VisitDreznica.Model.Constants;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Rooms;

namespace VisitDreznica.API.Controllers;

public class RoomsController : BaseCrudController<RoomResponse, RoomSearchObject, RoomUpsertRequest, RoomUpsertRequest>
{
    private readonly IRoomService _roomService;

    public RoomsController(IRoomService roomService) : base(roomService)
    {
        _roomService = roomService;
    }

    [HttpPost("{id:int}/images")]
    [Authorize(Roles = AppRoles.Admin)]
    public async Task<RoomImageResponse> UploadImage(int id, IFormFile file)
    {
        await using var stream = file.OpenReadStream();
        return await _roomService.AddImageAsync(id, stream, file.Length, file.ContentType);
    }

    [HttpGet("images/{imageId:int}")]
    public async Task<IActionResult> GetImage(int imageId)
    {
        var image = await _roomService.GetImageAsync(imageId);
        return File(image.Data, image.ContentType);
    }

    [HttpPut("images/{imageId:int}/cover")]
    [Authorize(Roles = AppRoles.Admin)]
    public async Task<IActionResult> SetCoverImage(int imageId)
    {
        await _roomService.SetCoverImageAsync(imageId);
        return NoContent();
    }

    [HttpDelete("images/{imageId:int}")]
    [Authorize(Roles = AppRoles.Admin)]
    public async Task<IActionResult> DeleteImage(int imageId)
    {
        await _roomService.DeleteImageAsync(imageId);
        return NoContent();
    }
}
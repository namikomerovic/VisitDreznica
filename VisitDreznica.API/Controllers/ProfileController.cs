using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Services.Database.Entities;
using VisitDreznica.Services.Images;
using VisitDreznica.Services.Security;
using VisitDreznica.Services.Users;

namespace VisitDreznica.API.Controllers;

[ApiController]
[Route("[controller]")]
[Authorize]
public class ProfileController(
    IUserService userService,
    IEntityImageService<User> imageService,
    ICurrentUser currentUser) : ControllerBase
{
    [HttpGet]
    public Task<UserResponse> Get() => userService.GetProfileAsync();

    [HttpPut]
    public Task<UserResponse> Update([FromBody] ProfileUpdateRequest request) => userService.UpdateProfileAsync(request);

    [HttpPut("password")]
    public async Task<IActionResult> ChangePassword([FromBody] ChangePasswordRequest request)
    {
        await userService.ChangePasswordAsync(request);
        return NoContent();
    }

    [HttpGet("image")]
    public async Task<IActionResult> GetImage()
    {
        var image = await imageService.GetImageAsync(currentUser.UserId);
        return File(image.Data, image.ContentType);
    }

    [HttpPut("image")]
    public async Task<IActionResult> SetImage(IFormFile file)
    {
        await using var stream = file.OpenReadStream();
        await imageService.SetImageAsync(currentUser.UserId, stream, file.Length, file.ContentType);
        return NoContent();
    }

    [HttpDelete("image")]
    public async Task<IActionResult> DeleteImage()
    {
        await imageService.DeleteImageAsync(currentUser.UserId);
        return NoContent();
    }
}
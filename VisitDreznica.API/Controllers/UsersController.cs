using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using VisitDreznica.API.Controllers.Base;
using VisitDreznica.Model.Constants;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Database.Entities;
using VisitDreznica.Services.Images;
using VisitDreznica.Services.Users;

namespace VisitDreznica.API.Controllers;

[Authorize(Roles = AppRoles.Admin)]
public class UsersController : BaseCrudController<UserResponse, UserSearchObject, UserInsertRequest, UserUpdateRequest>
{
    private readonly IEntityImageService<User> _imageService;

    public UsersController(IUserService service, IEntityImageService<User> imageService) : base(service)
    {
        _imageService = imageService;
    }

    [HttpGet("{id:int}/image")]
    public async Task<IActionResult> GetImage(int id)
    {
        var image = await _imageService.GetImageAsync(id);
        return File(image.Data, image.ContentType);
    }
}
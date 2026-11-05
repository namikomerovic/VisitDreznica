using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using VisitDreznica.Model.Constants;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Base;
using VisitDreznica.Services.Database.Entities;
using VisitDreznica.Services.Images;

namespace VisitDreznica.API.Controllers.Base;

public abstract class ImageCrudController<TEntity, TResponse, TSearch, TInsert, TUpdate>
    : BaseCrudController<TResponse, TSearch, TInsert, TUpdate>
    where TEntity : class, IHasImage
    where TResponse : class
    where TSearch : BaseSearchObject
{
    private readonly IEntityImageService<TEntity> _imageService;

    protected ImageCrudController(
        ICrudService<TResponse, TSearch, TInsert, TUpdate> service,
        IEntityImageService<TEntity> imageService) : base(service)
    {
        _imageService = imageService;
    }

    [HttpPut("{id:int}/image")]
    [Authorize(Roles = AppRoles.Admin)]
    public async Task<IActionResult> SetImage(int id, IFormFile file)
    {
        await using var stream = file.OpenReadStream();
        await _imageService.SetImageAsync(id, stream, file.Length, file.ContentType);
        return NoContent();
    }

    [HttpGet("{id:int}/image")]
    public async Task<IActionResult> GetImage(int id)
    {
        var image = await _imageService.GetImageAsync(id);
        return File(image.Data, image.ContentType);
    }

    [HttpDelete("{id:int}/image")]
    [Authorize(Roles = AppRoles.Admin)]
    public async Task<IActionResult> DeleteImage(int id)
    {
        await _imageService.DeleteImageAsync(id);
        return NoContent();
    }
}
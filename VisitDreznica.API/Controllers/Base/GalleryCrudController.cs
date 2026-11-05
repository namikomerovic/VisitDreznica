using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using VisitDreznica.Model.Constants;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Base;
using VisitDreznica.Services.Database.Entities;
using VisitDreznica.Services.Images;

namespace VisitDreznica.API.Controllers.Base;

public abstract class GalleryCrudController<TOwner, TImage, TResponse, TSearch, TInsert, TUpdate>
    : BaseCrudController<TResponse, TSearch, TInsert, TUpdate>
    where TOwner : class, IEntity
    where TImage : GalleryImage, new()
    where TResponse : class
    where TSearch : BaseSearchObject
{
    private readonly IGalleryImageService<TOwner, TImage> _galleryService;

    protected GalleryCrudController(
        ICrudService<TResponse, TSearch, TInsert, TUpdate> service,
        IGalleryImageService<TOwner, TImage> galleryService) : base(service)
    {
        _galleryService = galleryService;
    }

    [HttpPost("{id:int}/images")]
    [Authorize(Roles = AppRoles.Admin)]
    public async Task<GalleryImageResponse> UploadImage(int id, IFormFile file)
    {
        await using var stream = file.OpenReadStream();
        return await _galleryService.AddImageAsync(id, stream, file.Length, file.ContentType);
    }

    [HttpGet("images/{imageId:int}")]
    public async Task<IActionResult> GetImage(int imageId)
    {
        var image = await _galleryService.GetImageAsync(imageId);
        return File(image.Data, image.ContentType);
    }

    [HttpPut("images/{imageId:int}/cover")]
    [Authorize(Roles = AppRoles.Admin)]
    public async Task<IActionResult> SetCoverImage(int imageId)
    {
        await _galleryService.SetCoverImageAsync(imageId);
        return NoContent();
    }

    [HttpDelete("images/{imageId:int}")]
    [Authorize(Roles = AppRoles.Admin)]
    public async Task<IActionResult> DeleteImage(int imageId)
    {
        await _galleryService.DeleteImageAsync(imageId);
        return NoContent();
    }
}
using VisitDreznica.Model.Responses;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Images;

public interface IGalleryImageService<TOwner, TImage>
    where TOwner : class, IEntity
    where TImage : GalleryImage, new()
{
    Task<GalleryImageResponse> AddImageAsync(int ownerId, Stream content, long length, string declaredContentType);
    Task<FileContent> GetImageAsync(int imageId);
    Task SetCoverImageAsync(int imageId);
    Task DeleteImageAsync(int imageId);
}
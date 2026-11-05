using VisitDreznica.Model.Responses;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Images;

public interface IEntityImageService<TEntity> where TEntity : class, IHasImage
{
    Task SetImageAsync(int entityId, Stream content, long length, string declaredContentType);
    Task<FileContent> GetImageAsync(int entityId);
    Task DeleteImageAsync(int entityId);
}
using Microsoft.EntityFrameworkCore;
using VisitDreznica.Model.Exceptions;
using VisitDreznica.Model.Responses;
using VisitDreznica.Services.Database;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Images;

public class EntityImageService<TEntity>(VisitDreznicaDbContext dbContext) : IEntityImageService<TEntity>
    where TEntity : class, IHasImage
{
    public async Task SetImageAsync(int entityId, Stream content, long length, string declaredContentType)
    {
        var entity = await FindAsync(entityId);
        var file = await ImageValidator.ReadAndValidateAsync(content, length, declaredContentType);

        entity.ImageData = file.Data;
        entity.ImageContentType = file.ContentType;

        await dbContext.SaveChangesAsync();
    }

    public async Task<FileContent> GetImageAsync(int entityId)
    {
        return await dbContext.Set<TEntity>()
                   .Where(x => x.Id == entityId && x.ImageData != null)
                   .Select(x => new FileContent { Data = x.ImageData!, ContentType = x.ImageContentType! })
                   .FirstOrDefaultAsync()
               ?? throw new NotFoundException("Tražena slika ne postoji.");
    }

    public async Task DeleteImageAsync(int entityId)
    {
        var entity = await FindAsync(entityId);

        entity.ImageData = null;
        entity.ImageContentType = null;

        await dbContext.SaveChangesAsync();
    }

    private async Task<TEntity> FindAsync(int entityId) =>
        await dbContext.Set<TEntity>().FirstOrDefaultAsync(x => x.Id == entityId)
        ?? throw new NotFoundException("Traženi zapis ne postoji.");
}
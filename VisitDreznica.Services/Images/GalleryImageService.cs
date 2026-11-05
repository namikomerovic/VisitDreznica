using Microsoft.EntityFrameworkCore;
using VisitDreznica.Model.Exceptions;
using VisitDreznica.Model.Responses;
using VisitDreznica.Services.Database;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Images;

public class GalleryImageService<TOwner, TImage>(VisitDreznicaDbContext dbContext) : IGalleryImageService<TOwner, TImage>
    where TOwner : class, IEntity
    where TImage : GalleryImage, new()
{
    private DbSet<TImage> Images => dbContext.Set<TImage>();

    public async Task<GalleryImageResponse> AddImageAsync(int ownerId, Stream content, long length, string declaredContentType)
    {
        if (!await dbContext.Set<TOwner>().AnyAsync(x => x.Id == ownerId))
        {
            throw new NotFoundException("Traženi zapis ne postoji.");
        }

        var file = await ImageValidator.ReadAndValidateAsync(content, length, declaredContentType);
        var maxOrder = await Images.Where(x => x.OwnerId == ownerId).MaxAsync(x => (int?)x.DisplayOrder);

        var image = new TImage
        {
            OwnerId = ownerId,
            Data = file.Data,
            ContentType = file.ContentType,
            IsCover = maxOrder is null,
            DisplayOrder = (maxOrder ?? 0) + 1,
            CreatedAt = DateTime.UtcNow
        };

        Images.Add(image);
        await dbContext.SaveChangesAsync();

        return new GalleryImageResponse { Id = image.Id, IsCover = image.IsCover, DisplayOrder = image.DisplayOrder };
    }

    public async Task<FileContent> GetImageAsync(int imageId)
    {
        return await Images
                   .Where(x => x.Id == imageId)
                   .Select(x => new FileContent { Data = x.Data, ContentType = x.ContentType })
                   .FirstOrDefaultAsync()
               ?? throw new NotFoundException("Tražena slika ne postoji.");
    }

    public async Task SetCoverImageAsync(int imageId)
    {
        var ownerId = await Images.Where(x => x.Id == imageId).Select(x => (int?)x.OwnerId).FirstOrDefaultAsync()
                      ?? throw new NotFoundException("Tražena slika ne postoji.");

        await Images
            .Where(x => x.OwnerId == ownerId)
            .ExecuteUpdateAsync(setters => setters.SetProperty(x => x.IsCover, x => x.Id == imageId));
    }

    public async Task DeleteImageAsync(int imageId)
    {
        var image = await Images
                        .Where(x => x.Id == imageId)
                        .Select(x => new { x.OwnerId, x.IsCover })
                        .FirstOrDefaultAsync()
                    ?? throw new NotFoundException("Tražena slika ne postoji.");

        await using var transaction = await dbContext.Database.BeginTransactionAsync();

        await Images.Where(x => x.Id == imageId).ExecuteDeleteAsync();

        if (image.IsCover)
        {
            var nextCoverId = await Images
                .Where(x => x.OwnerId == image.OwnerId)
                .OrderBy(x => x.DisplayOrder)
                .Select(x => (int?)x.Id)
                .FirstOrDefaultAsync();

            if (nextCoverId.HasValue)
            {
                await Images
                    .Where(x => x.Id == nextCoverId.Value)
                    .ExecuteUpdateAsync(setters => setters.SetProperty(x => x.IsCover, true));
            }
        }

        await transaction.CommitAsync();
    }
}
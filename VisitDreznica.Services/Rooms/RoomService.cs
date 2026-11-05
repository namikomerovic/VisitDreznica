using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using VisitDreznica.Model.Constants;
using VisitDreznica.Model.Exceptions;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Base;
using VisitDreznica.Services.Database;
using VisitDreznica.Services.Database.Entities;
using VisitDreznica.Services.Images;
using VisitDreznica.Services.Security;

namespace VisitDreznica.Services.Rooms;

public class RoomService(VisitDreznicaDbContext dbContext, IMapper mapper, ICurrentUser currentUser)
    : BaseCrudService<Room, RoomResponse, RoomSearchObject, RoomUpsertRequest, RoomUpsertRequest>(dbContext, mapper),
      IRoomService
{
    protected override string EntityDisplayName => "soba";

    protected override IQueryable<Room> ApplyFilters(IQueryable<Room> query, RoomSearchObject search)
    {
        if (!currentUser.IsInRole(AppRoles.Admin))
        {
            query = query.Where(x => x.IsActive);
        }
        else if (search.IsActive.HasValue)
        {
            query = query.Where(x => x.IsActive == search.IsActive.Value);
        }

        if (!string.IsNullOrWhiteSpace(search.Name))
        {
            query = query.Where(x => x.Name.Contains(search.Name));
        }

        if (search.RoomTypeId.HasValue)
        {
            query = query.Where(x => x.RoomTypeId == search.RoomTypeId.Value);
        }

        if (search.MinCapacity.HasValue)
        {
            query = query.Where(x => x.Capacity >= search.MinCapacity.Value);
        }

        if (search.MaxPrice.HasValue)
        {
            query = query.Where(x => x.PricePerNight <= search.MaxPrice.Value);
        }

        return query;
    }

    protected override IQueryable<Room> ApplyOrdering(IQueryable<Room> query, RoomSearchObject search) =>
        query.OrderBy(x => x.Name);

    protected override Task BeforeInsertAsync(RoomUpsertRequest request) => ValidateAsync(request, excludeId: null);

    protected override Task BeforeUpdateAsync(Room entity, RoomUpsertRequest request) => ValidateAsync(request, excludeId: entity.Id);

    protected override Task AfterMapInsertAsync(Room entity, RoomUpsertRequest request)
    {
        entity.CreatedAt = DateTime.UtcNow;

        foreach (var amenityId in request.AmenityIds.Distinct())
        {
            entity.RoomAmenities.Add(new RoomAmenity { AmenityId = amenityId });
        }

        return Task.CompletedTask;
    }

    protected override async Task AfterMapUpdateAsync(Room entity, RoomUpsertRequest request)
    {
        entity.UpdatedAt = DateTime.UtcNow;

        var requestedIds = request.AmenityIds.Distinct().ToList();
        var current = await DbContext.RoomAmenities.Where(x => x.RoomId == entity.Id).ToListAsync();

        DbContext.RoomAmenities.RemoveRange(current.Where(x => !requestedIds.Contains(x.AmenityId)));

        var currentIds = current.Select(x => x.AmenityId).ToHashSet();
        foreach (var amenityId in requestedIds.Where(id => !currentIds.Contains(id)))
        {
            DbContext.RoomAmenities.Add(new RoomAmenity { RoomId = entity.Id, AmenityId = amenityId });
        }
    }

    public async Task<RoomImageResponse> AddImageAsync(int roomId, Stream content, long length, string declaredContentType)
    {
        if (!await DbContext.Rooms.AnyAsync(x => x.Id == roomId))
        {
            throw new NotFoundException("Traženi zapis (soba) ne postoji.");
        }

        var file = await ImageValidator.ReadAndValidateAsync(content, length, declaredContentType);
        var maxOrder = await DbContext.RoomImages.Where(x => x.RoomId == roomId).MaxAsync(x => (int?)x.DisplayOrder);

        var image = new RoomImage
        {
            RoomId = roomId,
            Data = file.Data,
            ContentType = file.ContentType,
            IsCover = maxOrder is null,
            DisplayOrder = (maxOrder ?? 0) + 1,
            CreatedAt = DateTime.UtcNow
        };

        DbContext.RoomImages.Add(image);
        await DbContext.SaveChangesAsync();

        return new RoomImageResponse { Id = image.Id, IsCover = image.IsCover, DisplayOrder = image.DisplayOrder };
    }

    public async Task<FileContent> GetImageAsync(int imageId)
    {
        return await DbContext.RoomImages
                   .Where(x => x.Id == imageId)
                   .Select(x => new FileContent { Data = x.Data, ContentType = x.ContentType })
                   .FirstOrDefaultAsync()
               ?? throw new NotFoundException("Tražena slika ne postoji.");
    }

    public async Task SetCoverImageAsync(int imageId)
    {
        var roomId = await GetRoomIdOfImageAsync(imageId);

        await DbContext.RoomImages
            .Where(x => x.RoomId == roomId)
            .ExecuteUpdateAsync(setters => setters.SetProperty(x => x.IsCover, x => x.Id == imageId));
    }

    public async Task DeleteImageAsync(int imageId)
    {
        var image = await DbContext.RoomImages
                        .Where(x => x.Id == imageId)
                        .Select(x => new { x.RoomId, x.IsCover })
                        .FirstOrDefaultAsync()
                    ?? throw new NotFoundException("Tražena slika ne postoji.");

        await using var transaction = await DbContext.Database.BeginTransactionAsync();

        await DbContext.RoomImages.Where(x => x.Id == imageId).ExecuteDeleteAsync();

        if (image.IsCover)
        {
            var nextCoverId = await DbContext.RoomImages
                .Where(x => x.RoomId == image.RoomId)
                .OrderBy(x => x.DisplayOrder)
                .Select(x => (int?)x.Id)
                .FirstOrDefaultAsync();

            if (nextCoverId.HasValue)
            {
                await DbContext.RoomImages
                    .Where(x => x.Id == nextCoverId.Value)
                    .ExecuteUpdateAsync(setters => setters.SetProperty(x => x.IsCover, true));
            }
        }

        await transaction.CommitAsync();
    }

    private async Task ValidateAsync(RoomUpsertRequest request, int? excludeId)
    {
        var trimmedName = request.Name.Trim();

        if (await DbContext.Rooms.AnyAsync(x => x.Name == trimmedName && x.Id != excludeId))
        {
            throw new BusinessException($"Soba s nazivom '{trimmedName}' već postoji.");
        }

        if (!await DbContext.RoomTypes.AnyAsync(x => x.Id == request.RoomTypeId))
        {
            throw new BusinessException("Odabrani tip sobe ne postoji.");
        }

        var amenityIds = request.AmenityIds.Distinct().ToList();
        var existingCount = await DbContext.Amenities.CountAsync(x => amenityIds.Contains(x.Id));

        if (existingCount != amenityIds.Count)
        {
            throw new BusinessException("Jedna ili više odabranih pogodnosti ne postoji.");
        }
    }

    private async Task<int> GetRoomIdOfImageAsync(int imageId) =>
        await DbContext.RoomImages.Where(x => x.Id == imageId).Select(x => (int?)x.RoomId).FirstOrDefaultAsync()
        ?? throw new NotFoundException("Tražena slika ne postoji.");
}
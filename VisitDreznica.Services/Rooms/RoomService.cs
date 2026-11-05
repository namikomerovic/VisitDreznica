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

}
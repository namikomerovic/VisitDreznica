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

namespace VisitDreznica.Services.Places;

public class PlaceService(VisitDreznicaDbContext dbContext, IMapper mapper, ICurrentUser currentUser)
    : BaseCrudService<Place, PlaceResponse, PlaceSearchObject, PlaceUpsertRequest, PlaceUpsertRequest>(dbContext, mapper),
      IPlaceService
{
    protected override string EntityDisplayName => "mjesto";

    protected override IQueryable<Place> ApplyFilters(IQueryable<Place> query, PlaceSearchObject search)
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

        if (search.PlaceTypeId.HasValue)
        {
            query = query.Where(x => x.PlaceTypeId == search.PlaceTypeId.Value);
        }

        return query;
    }

    protected override IQueryable<Place> ApplyOrdering(IQueryable<Place> query, PlaceSearchObject search) =>
        query.OrderBy(x => x.DistanceKm);

    protected override Task BeforeInsertAsync(PlaceUpsertRequest request) => ValidateAsync(request, excludeId: null);

    protected override Task BeforeUpdateAsync(Place entity, PlaceUpsertRequest request) => ValidateAsync(request, excludeId: entity.Id);

    protected override Task AfterMapInsertAsync(Place entity, PlaceUpsertRequest request)
    {
        entity.CreatedAt = DateTime.UtcNow;
        entity.DistanceKm = GeoDistance.FromAccommodationKm(entity.Latitude, entity.Longitude);
        return Task.CompletedTask;
    }

    protected override Task AfterMapUpdateAsync(Place entity, PlaceUpsertRequest request)
    {
        entity.UpdatedAt = DateTime.UtcNow;
        entity.DistanceKm = GeoDistance.FromAccommodationKm(entity.Latitude, entity.Longitude);
        return Task.CompletedTask;
    }

    private async Task ValidateAsync(PlaceUpsertRequest request, int? excludeId)
    {
        var trimmedName = request.Name.Trim();

        if (await DbContext.Places.AnyAsync(x => x.Name == trimmedName && x.Id != excludeId))
        {
            throw new BusinessException($"Mjesto s nazivom '{trimmedName}' već postoji.");
        }

        if (!await DbContext.PlaceTypes.AnyAsync(x => x.Id == request.PlaceTypeId))
        {
            throw new BusinessException("Odabrani tip mjesta ne postoji.");
        }
    }
}
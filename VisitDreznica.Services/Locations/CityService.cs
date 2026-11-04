using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using VisitDreznica.Model.Exceptions;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Base;
using VisitDreznica.Services.Database;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Locations;

public class CityService(VisitDreznicaDbContext dbContext, IMapper mapper)
    : BaseCrudService<City, CityResponse, CitySearchObject, CityUpsertRequest, CityUpsertRequest>(dbContext, mapper),
      ICityService
{
    protected override string EntityDisplayName => "grad";

    protected override IQueryable<City> ApplyFilters(IQueryable<City> query, CitySearchObject search)
    {
        if (!string.IsNullOrWhiteSpace(search.Name))
        {
            query = query.Where(x => x.Name.Contains(search.Name));
        }

        if (search.CountryId.HasValue)
        {
            query = query.Where(x => x.CountryId == search.CountryId.Value);
        }

        return query;
    }

    protected override IQueryable<City> ApplyOrdering(IQueryable<City> query, CitySearchObject search) =>
        query.OrderBy(x => x.Name);

    protected override Task BeforeInsertAsync(CityUpsertRequest request) => ValidateAsync(request, excludeId: null);

    protected override Task BeforeUpdateAsync(City entity, CityUpsertRequest request) => ValidateAsync(request, excludeId: entity.Id);

    protected override async Task BeforeDeleteAsync(City entity)
    {
        if (await DbContext.Users.AnyAsync(x => x.CityId == entity.Id))
        {
            throw new BusinessException("Grad nije moguće obrisati jer ga koriste korisnici.");
        }
    }

    private async Task ValidateAsync(CityUpsertRequest request, int? excludeId)
    {
        if (!await DbContext.Countries.AnyAsync(x => x.Id == request.CountryId))
        {
            throw new BusinessException("Odabrana država ne postoji.");
        }

        var trimmedName = request.Name.Trim();

        if (await DbContext.Cities.AnyAsync(x => x.CountryId == request.CountryId && x.Name == trimmedName && x.Id != excludeId))
        {
            throw new BusinessException($"Grad '{trimmedName}' već postoji u odabranoj državi.");
        }
    }
}
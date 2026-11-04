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

public class CountryService(VisitDreznicaDbContext dbContext, IMapper mapper)
    : BaseCrudService<Country, CountryResponse, CountrySearchObject, CountryUpsertRequest, CountryUpsertRequest>(dbContext, mapper),
      ICountryService
{
    protected override string EntityDisplayName => "država";

    protected override IQueryable<Country> ApplyFilters(IQueryable<Country> query, CountrySearchObject search)
    {
        if (!string.IsNullOrWhiteSpace(search.Name))
        {
            query = query.Where(x => x.Name.Contains(search.Name));
        }

        return query;
    }

    protected override IQueryable<Country> ApplyOrdering(IQueryable<Country> query, CountrySearchObject search) =>
        query.OrderBy(x => x.Name);

    protected override Task BeforeInsertAsync(CountryUpsertRequest request) =>
        EnsureUniqueNameAsync(request.Name, excludeId: null);

    protected override Task BeforeUpdateAsync(Country entity, CountryUpsertRequest request) =>
        EnsureUniqueNameAsync(request.Name, excludeId: entity.Id);

    protected override async Task BeforeDeleteAsync(Country entity)
    {
        if (await DbContext.Cities.AnyAsync(x => x.CountryId == entity.Id))
        {
            throw new BusinessException("Državu nije moguće obrisati jer za nju postoje gradovi.");
        }
    }

    private async Task EnsureUniqueNameAsync(string name, int? excludeId)
    {
        var trimmedName = name.Trim();

        if (await DbContext.Countries.AnyAsync(x => x.Name == trimmedName && x.Id != excludeId))
        {
            throw new BusinessException($"Država s nazivom '{trimmedName}' već postoji.");
        }
    }
}
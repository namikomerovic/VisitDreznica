using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using VisitDreznica.Model.Exceptions;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Base;
using VisitDreznica.Services.Database;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Lookups;

public class LookupService<TEntity>(VisitDreznicaDbContext dbContext, IMapper mapper)
    : BaseCrudService<TEntity, LookupResponse, LookupSearchObject, LookupUpsertRequest, LookupUpsertRequest>(dbContext, mapper),
      ILookupService<TEntity>
    where TEntity : LookupEntity
{
    protected override string EntityDisplayName => "stavka šifarnika";

    protected override IQueryable<TEntity> ApplyFilters(IQueryable<TEntity> query, LookupSearchObject search)
    {
        if (!string.IsNullOrWhiteSpace(search.Name))
        {
            query = query.Where(x => x.Name.Contains(search.Name));
        }

        return query;
    }

    protected override IQueryable<TEntity> ApplyOrdering(IQueryable<TEntity> query, LookupSearchObject search) =>
        query.OrderBy(x => x.Name);

    protected override Task BeforeInsertAsync(LookupUpsertRequest request) =>
        EnsureUniqueNameAsync(request.Name, excludeId: null);

    protected override Task BeforeUpdateAsync(TEntity entity, LookupUpsertRequest request) =>
        EnsureUniqueNameAsync(request.Name, excludeId: entity.Id);

    private async Task EnsureUniqueNameAsync(string name, int? excludeId)
    {
        var trimmedName = name.Trim();

        if (await DbContext.Set<TEntity>().AnyAsync(x => x.Name == trimmedName && x.Id != excludeId))
        {
            throw new BusinessException($"Stavka s nazivom '{trimmedName}' već postoji.");
        }
    }
}
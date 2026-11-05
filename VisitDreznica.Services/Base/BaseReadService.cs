using Mapster;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using VisitDreznica.Model.Exceptions;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Database;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Base;

public abstract class BaseReadService<TEntity, TResponse, TSearch>(VisitDreznicaDbContext dbContext, IMapper mapper)
    : IReadService<TResponse, TSearch>
    where TEntity : class, IEntity
    where TResponse : class
    where TSearch : BaseSearchObject
{
    protected VisitDreznicaDbContext DbContext { get; } = dbContext;
    protected IMapper Mapper { get; } = mapper;

    protected virtual string EntityDisplayName => typeof(TEntity).Name;

public virtual async Task<PageResult<TResponse>> GetPagedAsync(TSearch search)
{
    var query = ApplyFilters(DbContext.Set<TEntity>().AsNoTracking(), search);

    var totalCount = await query.CountAsync();
    var page = Math.Max(search.Page, 1);
    var pageSize = Math.Clamp(search.PageSize, 1, BaseSearchObject.MaxPageSize);

    var pagedQuery = ApplyOrdering(query, search)
        .Skip((page - 1) * pageSize)
        .Take(pageSize);

    var items = await Project(pagedQuery).ToListAsync();

    return new PageResult<TResponse>
    {
        Items = items,
        TotalCount = totalCount,
        Page = page,
        PageSize = pageSize
    };
}

public virtual async Task<TResponse> GetByIdAsync(int id)
{
    return await Project(DbContext.Set<TEntity>().AsNoTracking().Where(x => x.Id == id))
               .FirstOrDefaultAsync()
           ?? throw new NotFoundException($"Traženi zapis ({EntityDisplayName}) ne postoji.");
}


    protected virtual IQueryable<TEntity> ApplyFilters(IQueryable<TEntity> query, TSearch search) => query;

    protected virtual IQueryable<TEntity> ApplyOrdering(IQueryable<TEntity> query, TSearch search) =>
        query.OrderByDescending(x => x.Id);

    protected virtual IQueryable<TResponse> Project(IQueryable<TEntity> query) =>
        query.ProjectToType<TResponse>(Mapper.Config);
}
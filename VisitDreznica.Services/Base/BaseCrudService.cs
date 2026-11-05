using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using VisitDreznica.Model.Exceptions;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Database;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Base;

public abstract class BaseCrudService<TEntity, TResponse, TSearch, TInsert, TUpdate>(VisitDreznicaDbContext dbContext, IMapper mapper)
    : BaseReadService<TEntity, TResponse, TSearch>(dbContext, mapper),
      ICrudService<TResponse, TSearch, TInsert, TUpdate>
    where TEntity : class, IEntity
    where TResponse : class
    where TSearch : BaseSearchObject
{
    public virtual async Task<TResponse> InsertAsync(TInsert request)
    {
        await BeforeInsertAsync(request);

        var entity = Mapper.Map<TEntity>(request!);
        await AfterMapInsertAsync(entity, request);

        DbContext.Set<TEntity>().Add(entity);
        await DbContext.SaveChangesAsync();

        return await GetByIdAsync(entity.Id);
    }

    public virtual async Task<TResponse> UpdateAsync(int id, TUpdate request)
    {
        var entity = await FindEntityAsync(id);
        await BeforeUpdateAsync(entity, request);

        Mapper.Map(request, entity);
        await AfterMapUpdateAsync(entity, request);

        await DbContext.SaveChangesAsync();

        return await GetByIdAsync(id);
    }

    public virtual async Task DeleteAsync(int id)
    {
        var entity = await FindEntityAsync(id);
        await BeforeDeleteAsync(entity);

        DbContext.Set<TEntity>().Remove(entity);

        try
        {
            await DbContext.SaveChangesAsync();
        }
        catch (DbUpdateException ex)
        {
            throw new BusinessException("Zapis nije moguće obrisati jer ga koriste drugi podaci.", ex);
        }
    }

    protected async Task<TEntity> FindEntityAsync(int id) =>
        await DbContext.Set<TEntity>().FirstOrDefaultAsync(x => x.Id == id)
        ?? throw new NotFoundException($"Traženi zapis ({EntityDisplayName}) ne postoji.");

    protected virtual Task BeforeInsertAsync(TInsert request) => Task.CompletedTask;
    protected virtual Task BeforeUpdateAsync(TEntity entity, TUpdate request) => Task.CompletedTask;
    protected virtual Task BeforeDeleteAsync(TEntity entity) => Task.CompletedTask;
    protected virtual Task AfterMapInsertAsync(TEntity entity, TInsert request) => Task.CompletedTask;
    protected virtual Task AfterMapUpdateAsync(TEntity entity, TUpdate request) => Task.CompletedTask;
}
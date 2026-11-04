using VisitDreznica.Model.SearchObjects;

namespace VisitDreznica.Services.Base;

public interface ICrudService<TResponse, TSearch, TInsert, TUpdate> : IReadService<TResponse, TSearch>
    where TResponse : class
    where TSearch : BaseSearchObject
{
    Task<TResponse> InsertAsync(TInsert request);
    Task<TResponse> UpdateAsync(int id, TUpdate request);
    Task DeleteAsync(int id);
}
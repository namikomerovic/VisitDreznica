using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;

namespace VisitDreznica.Services.Base;

public interface IReadService<TResponse, TSearch>
    where TResponse : class
    where TSearch : BaseSearchObject
{
    Task<PageResult<TResponse>> GetPagedAsync(TSearch search);
    Task<TResponse> GetByIdAsync(int id);
}
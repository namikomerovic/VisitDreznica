using Microsoft.AspNetCore.Mvc;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Base;

namespace VisitDreznica.API.Controllers.Base;

public abstract class BaseCrudController<TResponse, TSearch, TInsert, TUpdate> : BaseReadController<TResponse, TSearch>
    where TResponse : class
    where TSearch : BaseSearchObject
{
    private readonly ICrudService<TResponse, TSearch, TInsert, TUpdate> _service;

    protected BaseCrudController(ICrudService<TResponse, TSearch, TInsert, TUpdate> service) : base(service)
    {
        _service = service;
    }

    [HttpPost]
    public virtual Task<TResponse> Insert([FromBody] TInsert request) => _service.InsertAsync(request);

    [HttpPut("{id:int}")]
    public virtual Task<TResponse> Update(int id, [FromBody] TUpdate request) => _service.UpdateAsync(id, request);

    [HttpDelete("{id:int}")]
    public virtual async Task<IActionResult> Delete(int id)
    {
        await _service.DeleteAsync(id);
        return NoContent();
    }
}
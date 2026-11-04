using Microsoft.AspNetCore.Mvc;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Base;
using Microsoft.AspNetCore.Authorization;

namespace VisitDreznica.API.Controllers.Base;

[ApiController]
[Route("[controller]")]
[Authorize]
public abstract class BaseReadController<TResponse, TSearch> : ControllerBase
    where TResponse : class
    where TSearch : BaseSearchObject
{
    private readonly IReadService<TResponse, TSearch> _service;

    protected BaseReadController(IReadService<TResponse, TSearch> service)
    {
        _service = service;
    }

    [HttpGet]
    public virtual Task<PageResult<TResponse>> Get([FromQuery] TSearch search) => _service.GetPagedAsync(search);

    [HttpGet("{id:int}")]
    public virtual Task<TResponse> GetById(int id) => _service.GetByIdAsync(id);
}
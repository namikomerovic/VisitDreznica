using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using VisitDreznica.Model.Constants;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Interactions;
using VisitDreznica.Model.Enums;

namespace VisitDreznica.API.Controllers;

[ApiController]
[Route("[controller]")]
[Authorize]
public class ReviewsController(IReviewService reviewService) : ControllerBase
{
    [HttpGet]
    public Task<PageResult<ReviewResponse>> Get([FromQuery] ReviewSearchObject search) =>
        reviewService.GetPagedAsync(search);

    [HttpGet("{id:int}")]
    public Task<ReviewResponse> GetById(int id) => reviewService.GetByIdAsync(id);

    [HttpGet("summary")]
    public Task<ReviewSummaryResponse> Summary([FromQuery] ItemReferenceRequest item) =>
        reviewService.GetSummaryAsync(item);

    [HttpGet("summaries")]
    public Task<List<ReviewSummaryItemResponse>> Summaries([FromQuery] ItemType itemType) =>
        reviewService.GetSummariesAsync(itemType);

    [HttpPost]
    [Authorize(Roles = AppRoles.Guest)]
    public Task<ReviewResponse> Create([FromBody] ReviewInsertRequest request) =>
        reviewService.CreateAsync(request);

    [HttpPut("{id:int}")]
    [Authorize(Roles = AppRoles.Guest)]
    public Task<ReviewResponse> Update(int id, [FromBody] ReviewUpdateRequest request) =>
        reviewService.UpdateAsync(id, request);

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        await reviewService.DeleteAsync(id);
        return NoContent();
    }
}
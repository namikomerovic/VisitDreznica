using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using VisitDreznica.Model.Constants;
using VisitDreznica.Model.Enums;
using VisitDreznica.Model.Responses;
using VisitDreznica.Services.Recommendations;

namespace VisitDreznica.API.Controllers;

[ApiController]
[Route("[controller]")]
[Authorize]
public class RecommendationsController(
    IRecommendationService recommendationService,
    IRecommenderTrainer recommenderTrainer) : ControllerBase
{
    [HttpGet]
    [Authorize(Roles = AppRoles.Guest)]
    public Task<List<RecommendationResponse>> Get([FromQuery] ItemType? itemType, [FromQuery] int take = 10) =>
        recommendationService.GetForCurrentUserAsync(itemType, take);

    [HttpGet("model")]
    [Authorize(Roles = AppRoles.Admin)]
    public RecommenderModelResponse GetModel() => recommendationService.GetModelInfo();

    [HttpPost("train")]
    [Authorize(Roles = AppRoles.Admin)]
    public Task<RecommenderModelResponse> Train(CancellationToken cancellationToken) =>
        recommenderTrainer.TrainAsync(cancellationToken);
}
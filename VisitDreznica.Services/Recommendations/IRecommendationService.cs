using VisitDreznica.Model.Enums;
using VisitDreznica.Model.Responses;

namespace VisitDreznica.Services.Recommendations;

public interface IRecommendationService
{
    Task<List<RecommendationResponse>> GetForCurrentUserAsync(ItemType? itemType, int take);
    RecommenderModelResponse GetModelInfo();
}
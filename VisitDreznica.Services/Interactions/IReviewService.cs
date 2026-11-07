using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Base;
using VisitDreznica.Model.Enums;

namespace VisitDreznica.Services.Interactions;

public interface IReviewService : IReadService<ReviewResponse, ReviewSearchObject>
{
    Task<ReviewSummaryResponse> GetSummaryAsync(ItemReferenceRequest item);
    Task<ReviewResponse> CreateAsync(ReviewInsertRequest request);
    Task<ReviewResponse> UpdateAsync(int id, ReviewUpdateRequest request);
    Task DeleteAsync(int id);
    Task<List<ReviewSummaryItemResponse>> GetSummariesAsync(ItemType itemType);
}
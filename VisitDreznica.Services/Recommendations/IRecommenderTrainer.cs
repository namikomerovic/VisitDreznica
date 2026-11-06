using VisitDreznica.Model.Responses;

namespace VisitDreznica.Services.Recommendations;

public interface IRecommenderTrainer
{
    Task<RecommenderModelResponse> TrainAsync(CancellationToken cancellationToken);
}
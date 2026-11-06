namespace VisitDreznica.Services.Recommendations;

public interface IRecommenderModelStore
{
    RecommenderSnapshot? Current { get; }
    SemaphoreSlim TrainingLock { get; }
    void Set(RecommenderSnapshot snapshot);
}
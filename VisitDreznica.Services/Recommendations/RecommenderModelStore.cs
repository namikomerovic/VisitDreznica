namespace VisitDreznica.Services.Recommendations;

public sealed class RecommenderModelStore : IRecommenderModelStore
{
    private volatile RecommenderSnapshot? current;

    public RecommenderSnapshot? Current => current;

    public SemaphoreSlim TrainingLock { get; } = new(1, 1);

    public void Set(RecommenderSnapshot snapshot) => current = snapshot;
}
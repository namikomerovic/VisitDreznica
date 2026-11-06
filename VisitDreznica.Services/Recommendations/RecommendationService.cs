using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using VisitDreznica.Model.Enums;
using VisitDreznica.Model.Exceptions;
using VisitDreznica.Model.Responses;
using VisitDreznica.Services.Database;
using VisitDreznica.Services.Database.Entities;
using VisitDreznica.Services.Security;

namespace VisitDreznica.Services.Recommendations;

public class RecommendationService(
    VisitDreznicaDbContext dbContext,
    ICurrentUser currentUser,
    IRecommenderModelStore store) : IRecommendationService
{
    private const int MaxTake = 20;
    private const int PopularityPrior = 3;
    private const double MinSimilarity = 0.1;

    public async Task<List<RecommendationResponse>> GetForCurrentUserAsync(ItemType? itemType, int take)
    {
        var snapshot = store.Current
                       ?? throw new BusinessException("Preporuke se još pripremaju. Pokušajte za nekoliko trenutaka.");

        take = Math.Clamp(take, 1, MaxTake);
        var userId = currentUser.UserId;

        var catalog = await LoadCatalogAsync();
        var userItems = snapshot.UserItems.GetValueOrDefault(userId);
        var excluded = await LoadExcludedAsync(userId, userItems);

        var candidates = catalog.Values
            .Where(x => (itemType is null || x.Type == itemType) && !excluded.Contains(x.Key))
            .ToList();

        if (candidates.Count == 0)
        {
            return [];
        }

        if (snapshot.Model is not null && userItems is not null)
        {
            var personal = ScoreWithModel(snapshot.Model, userId, candidates, take);

            if (personal.Count > 0)
            {
                return personal
                    .Select(x => ToResponse(x.Item, x.Score, ExplainPersonal(snapshot, userItems, catalog, x.Item), true))
                    .ToList();
            }
        }

        return Popular(snapshot, candidates, take);
    }

    public RecommenderModelResponse GetModelInfo() =>
        store.Current?.ToResponse() ?? new RecommenderModelResponse { Note = "Model još nije treniran." };

    private static List<(CatalogItem Item, double Score)> ScoreWithModel(
        ImplicitMfModel model, int userId, List<CatalogItem> candidates, int take)
    {
        if (!model.KnowsUser(userId))
        {
            return [];
        }

        var known = candidates.Where(x => model.KnowsItem(x.Key)).ToList();
        var scores = model.Predict(known.Select(x => (userId, x.Key)).ToList());

        return known
            .Select((item, index) => (Item: item, Score: Math.Round(scores[index], 2)))
            .OrderByDescending(x => x.Score)
            .Take(take)
            .ToList();
    }    private static List<RecommendationResponse> Popular(RecommenderSnapshot snapshot, List<CatalogItem> candidates, int take)
    {
        var mean = snapshot.GlobalMean > 0 ? snapshot.GlobalMean : 3.5;

        return candidates
            .Select(item =>
            {
                var users = snapshot.ItemUsers.GetValueOrDefault(item.Key);
                var count = users?.Count ?? 0;
                var sum = users?.Values.Sum(x => (double)x) ?? 0;
                var score = (sum + PopularityPrior * mean) / (count + PopularityPrior);

                return (Item: item, Score: Math.Round(score, 2), Count: count);
            })
            .OrderByDescending(x => x.Score)
            .ThenByDescending(x => x.Count)
            .Take(take)
            .Select(x => ToResponse(x.Item, x.Score,
                x.Count > 0 ? "Popularno među gostima." : "Iz naše ponude.", false))
            .ToList();
    }

    private static string ExplainPersonal(
        RecommenderSnapshot snapshot,
        Dictionary<string, float> userItems,
        Dictionary<string, CatalogItem> catalog,
        CatalogItem recommended)
    {
        if (!snapshot.ItemUsers.TryGetValue(recommended.Key, out var recommendedUsers))
        {
            return "Odgovara vašim dosadašnjim interesima.";
        }

        var best = userItems
            .Where(x => x.Value >= InteractionWeights.LikedThreshold && catalog.ContainsKey(x.Key))
            .Select(x => (Key: x.Key, Similarity: snapshot.ItemUsers.TryGetValue(x.Key, out var likedUsers)
                ? Cosine(recommendedUsers, likedUsers)
                : 0))
            .OrderByDescending(x => x.Similarity)
            .FirstOrDefault();

        return best.Key is not null && best.Similarity >= MinSimilarity
            ? $"Gostima kojima se svidjelo „{catalog[best.Key].Name}“ često se sviđa i ovo."
            : "Odgovara vašim dosadašnjim interesima.";
    }

    private static double Cosine(Dictionary<int, float> a, Dictionary<int, float> b)
    {
        double dot = 0;

        foreach (var (user, score) in a)
        {
            if (b.TryGetValue(user, out var other))
            {
                dot += score * other;
            }
        }

        if (dot == 0)
        {
            return 0;
        }

        var normA = Math.Sqrt(a.Values.Sum(x => (double)x * x));
        var normB = Math.Sqrt(b.Values.Sum(x => (double)x * x));

        return dot / (normA * normB);
    }

    private async Task<HashSet<string>> LoadExcludedAsync(int userId, Dictionary<string, float>? userItems)
    {
        var reviewed = await dbContext.Reviews.AsNoTracking()
            .Where(x => x.UserId == userId)
            .Select(x => new { x.RoomId, x.EquipmentId, x.ActivityId, x.PlaceId })
            .ToListAsync();

        var favorites = await dbContext.Favorites.AsNoTracking()
            .Where(x => x.UserId == userId)
            .Select(x => new { x.RoomId, x.EquipmentId, x.ActivityId, x.PlaceId })
            .ToListAsync();

        var excluded = reviewed.Concat(favorites)
            .Select(x => ItemKeys.From(x.RoomId, x.EquipmentId, x.ActivityId, x.PlaceId))
            .OfType<string>()
            .ToHashSet();

        if (userItems is not null)
        {
            excluded.UnionWith(userItems
                .Where(x => x.Value >= InteractionWeights.LikedThreshold)
                .Select(x => x.Key));
        }

        return excluded;
    }

    private async Task<Dictionary<string, CatalogItem>> LoadCatalogAsync()
    {
        var items = new List<CatalogItem>();

        items.AddRange(await dbContext.Set<Room>().AsNoTracking().Where(x => x.IsActive)
            .Select(x => new CatalogItem(ItemType.Room, x.Id, x.Name)).ToListAsync());

        items.AddRange(await dbContext.Set<Equipment>().AsNoTracking().Where(x => x.IsActive)
            .Select(x => new CatalogItem(ItemType.Equipment, x.Id, x.Name)).ToListAsync());

        items.AddRange(await dbContext.Set<Activity>().AsNoTracking().Where(x => x.IsActive)
            .Select(x => new CatalogItem(ItemType.Activity, x.Id, x.Name)).ToListAsync());

        items.AddRange(await dbContext.Set<Place>().AsNoTracking().Where(x => x.IsActive)
            .Select(x => new CatalogItem(ItemType.Place, x.Id, x.Name)).ToListAsync());

        return items.ToDictionary(x => x.Key);
    }

    private static RecommendationResponse ToResponse(CatalogItem item, double score, string reason, bool isPersonalized) => new()
    {
        ItemType = item.Type,
        ItemId = item.Id,
        ItemName = item.Name,
        Score = score,
        Reason = reason,
        IsPersonalized = isPersonalized
    };

    private sealed record CatalogItem(ItemType Type, int Id, string Name)
    {
        public string Key => ItemKeys.From(Type, Id);
    }
}
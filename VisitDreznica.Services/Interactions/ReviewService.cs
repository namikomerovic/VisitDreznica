using System.Linq.Expressions;
using MapsterMapper;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using VisitDreznica.Model.Constants;
using VisitDreznica.Model.Enums;
using VisitDreznica.Model.Exceptions;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Base;
using VisitDreznica.Services.Database;
using VisitDreznica.Services.Database.Entities;
using VisitDreznica.Services.Security;

namespace VisitDreznica.Services.Interactions;

public class ReviewService(VisitDreznicaDbContext dbContext, IMapper mapper, ICurrentUser currentUser)
    : BaseReadService<Review, ReviewResponse, ReviewSearchObject>(dbContext, mapper), IReviewService
{
    private const string AlreadyReviewedMessage = "Već ste ocijenili ovu stavku. Možete izmijeniti postojeću recenziju.";

    private static readonly Expression<Func<Review, ReviewResponse>> ToResponse = x => new ReviewResponse
    {
        Id = x.Id,
        ItemType = x.RoomId != null ? ItemType.Room
            : x.EquipmentId != null ? ItemType.Equipment
            : x.ActivityId != null ? ItemType.Activity
            : ItemType.Place,
        ItemId = x.RoomId ?? x.EquipmentId ?? x.ActivityId ?? x.PlaceId ?? 0,
        ItemName = x.Room != null ? x.Room.Name
            : x.Equipment != null ? x.Equipment.Name
            : x.Activity != null ? x.Activity.Name
            : x.Place!.Name,
        Rating = x.Rating,
        Comment = x.Comment,
        CreatedAt = x.CreatedAt,
        UpdatedAt = x.UpdatedAt,
        UserId = x.UserId,
        UserFullName = x.User.FirstName + " " + x.User.LastName
    };

    protected override string EntityDisplayName => "recenzija";

    protected override IQueryable<ReviewResponse> Project(IQueryable<Review> query) => query.Select(ToResponse);

    protected override IQueryable<Review> ApplyFilters(IQueryable<Review> query, ReviewSearchObject search)
    {
        if (search.ItemType.HasValue && search.ItemId.HasValue)
        {
            query = query.Where(ItemTargets.Matches<Review>(search.ItemType.Value, search.ItemId.Value));
        }
        else if (search.ItemType.HasValue)
        {
            query = query.Where(ItemTargets.OfType<Review>(search.ItemType.Value));
        }

        if (search.OnlyMine)
        {
            var userId = currentUser.UserId;
            query = query.Where(x => x.UserId == userId);
        }
        else if (search.UserId.HasValue)
        {
            query = query.Where(x => x.UserId == search.UserId.Value);
        }

        if (search.MinRating.HasValue)
        {
            query = query.Where(x => x.Rating >= search.MinRating.Value);
        }

        if (search.MaxRating.HasValue)
        {
            query = query.Where(x => x.Rating <= search.MaxRating.Value);
        }

        return query;
    }

    protected override IQueryable<Review> ApplyOrdering(IQueryable<Review> query, ReviewSearchObject search) =>
        query.OrderByDescending(x => x.CreatedAt);

    public async Task<ReviewSummaryResponse> GetSummaryAsync(ItemReferenceRequest item)
    {
        var reviews = DbContext.Reviews.AsNoTracking()
            .Where(ItemTargets.Matches<Review>(item.ItemType, item.ItemId));

        var counts = await reviews
            .GroupBy(x => x.Rating)
            .Select(g => new { Rating = g.Key, Count = g.Count() })
            .ToListAsync();

        var total = counts.Sum(x => x.Count);

        var summary = new ReviewSummaryResponse
        {
            ReviewCount = total,
            AverageRating = total == 0 ? null : Math.Round(counts.Sum(x => x.Rating * x.Count) / (double)total, 1),
            RatingCounts = Enumerable.Range(1, 5)
                .Select(rating => counts.FirstOrDefault(x => x.Rating == rating)?.Count ?? 0)
                .ToList()
        };

        if (currentUser.IsInRole(AppRoles.Guest))
        {
            var userId = currentUser.UserId;
            summary.MyReview = await reviews.Where(x => x.UserId == userId).Select(ToResponse).FirstOrDefaultAsync();
            summary.CanReview = summary.MyReview is null &&
                                await ItemTargets.HasUsedAsync(DbContext, userId, item.ItemType, item.ItemId);
        }

        return summary;
    }

    public async Task<List<ReviewSummaryItemResponse>> GetSummariesAsync(ItemType itemType) =>
        await DbContext.Reviews.AsNoTracking()
            .Where(ItemTargets.OfType<Review>(itemType))
            .Select(x => new { ItemId = x.RoomId ?? x.EquipmentId ?? x.ActivityId ?? x.PlaceId ?? 0, x.Rating })
            .GroupBy(x => x.ItemId)
            .Select(g => new ReviewSummaryItemResponse
            {
                ItemId = g.Key,
                AverageRating = Math.Round(g.Average(x => (double)x.Rating), 1),
                ReviewCount = g.Count()
            })
            .ToListAsync();
    public async Task<ReviewResponse> CreateAsync(ReviewInsertRequest request)
    {
        var userId = currentUser.UserId;

        await ItemTargets.EnsureExistsAsync(DbContext, request.ItemType, request.ItemId);

        var alreadyReviewed = await DbContext.Reviews
            .Where(ItemTargets.Matches<Review>(request.ItemType, request.ItemId))
            .AnyAsync(x => x.UserId == userId);

        if (alreadyReviewed)
        {
            throw new BusinessException(AlreadyReviewedMessage);
        }

        if (!await ItemTargets.HasUsedAsync(DbContext, userId, request.ItemType, request.ItemId))
        {
            throw new BusinessException("Recenziju možete ostaviti tek nakon završene rezervacije.");
        }

        var review = new Review
        {
            UserId = userId,
            Rating = request.Rating,
            Comment = Normalize(request.Comment),
            CreatedAt = DateTime.UtcNow
        };

        ItemTargets.Assign(review, request.ItemType, request.ItemId);
        DbContext.Reviews.Add(review);

        try
        {
            await DbContext.SaveChangesAsync();
        }
        catch (DbUpdateException ex) when (ex.InnerException is SqlException { Number: 2601 or 2627 })
        {
            throw new BusinessException(AlreadyReviewedMessage);
        }

        return await GetByIdAsync(review.Id);
    }

    public async Task<ReviewResponse> UpdateAsync(int id, ReviewUpdateRequest request)
    {
        var userId = currentUser.UserId;

        var review = await DbContext.Reviews.FirstOrDefaultAsync(x => x.Id == id && x.UserId == userId)
                     ?? throw new NotFoundException("Tražena recenzija ne postoji.");

        review.Rating = request.Rating;
        review.Comment = Normalize(request.Comment);
        review.UpdatedAt = DateTime.UtcNow;

        await DbContext.SaveChangesAsync();

        return await GetByIdAsync(id);
    }

    public async Task DeleteAsync(int id)
    {
        var query = DbContext.Reviews.Where(x => x.Id == id);

        if (!currentUser.IsInRole(AppRoles.Admin))
        {
            var userId = currentUser.UserId;
            query = query.Where(x => x.UserId == userId);
        }

        var review = await query.FirstOrDefaultAsync()
                     ?? throw new NotFoundException("Tražena recenzija ne postoji.");

        DbContext.Reviews.Remove(review);
        await DbContext.SaveChangesAsync();
    }

    private static string? Normalize(string? comment) =>
        string.IsNullOrWhiteSpace(comment) ? null : comment.Trim();
}
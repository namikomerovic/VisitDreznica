using System.Linq.Expressions;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using VisitDreznica.Model.Enums;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Services.Database;
using VisitDreznica.Services.Database.Entities;
using VisitDreznica.Services.Security;

namespace VisitDreznica.Services.Interactions;

public class FavoriteService(VisitDreznicaDbContext dbContext, ICurrentUser currentUser) : IFavoriteService
{
    private static readonly Expression<Func<Favorite, FavoriteResponse>> ToResponse = x => new FavoriteResponse
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
        CreatedAt = x.CreatedAt
    };

    public async Task<List<FavoriteResponse>> GetMineAsync(ItemType? itemType)
    {
        var userId = currentUser.UserId;
        var query = dbContext.Favorites.AsNoTracking().Where(x => x.UserId == userId);

        if (itemType.HasValue)
        {
            query = query.Where(ItemTargets.OfType<Favorite>(itemType.Value));
        }

        return await query.OrderByDescending(x => x.CreatedAt).Select(ToResponse).ToListAsync();
    }

    public async Task<FavoriteResponse> AddAsync(ItemReferenceRequest item)
    {
        var userId = currentUser.UserId;

        var existing = await FindAsync(userId, item);

        if (existing is not null)
        {
            return existing;
        }

        await ItemTargets.EnsureExistsAsync(dbContext, item.ItemType, item.ItemId);

        var favorite = new Favorite { UserId = userId, CreatedAt = DateTime.UtcNow };
        ItemTargets.Assign(favorite, item.ItemType, item.ItemId);
        dbContext.Favorites.Add(favorite);

        try
        {
            await dbContext.SaveChangesAsync();
        }
        catch (DbUpdateException ex) when (ex.InnerException is SqlException { Number: 2601 or 2627 })
        {
            dbContext.ChangeTracker.Clear();
        }

        return (await FindAsync(userId, item))!;
    }

    public async Task RemoveAsync(ItemReferenceRequest item)
    {
        var userId = currentUser.UserId;

        await dbContext.Favorites
            .Where(ItemTargets.Matches<Favorite>(item.ItemType, item.ItemId))
            .Where(x => x.UserId == userId)
            .ExecuteDeleteAsync();
    }

    private Task<FavoriteResponse?> FindAsync(int userId, ItemReferenceRequest item) =>
        dbContext.Favorites.AsNoTracking()
            .Where(ItemTargets.Matches<Favorite>(item.ItemType, item.ItemId))
            .Where(x => x.UserId == userId)
            .Select(ToResponse)
            .FirstOrDefaultAsync();
}
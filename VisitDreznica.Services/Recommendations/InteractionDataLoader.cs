using Microsoft.EntityFrameworkCore;
using VisitDreznica.Model.Enums;
using VisitDreznica.Services.Database;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Recommendations;

internal static class InteractionDataLoader
{
    private static readonly ReservationStatus[] CountedStatuses = [ReservationStatus.Confirmed, ReservationStatus.Completed];

    public static async Task<List<UserItemScore>> LoadAsync(VisitDreznicaDbContext dbContext, CancellationToken cancellationToken)
    {
        var implicitScores = new Dictionary<(int UserId, string ItemKey), float>();

        void Add(int userId, string? itemKey, float score)
        {
            if (itemKey is null)
            {
                return;
            }

            var key = (userId, itemKey);

            if (!implicitScores.TryGetValue(key, out var current) || score > current)
            {
                implicitScores[key] = score;
            }
        }

        var views = await dbContext.ContentViews.AsNoTracking()
            .GroupBy(x => new { x.UserId, x.RoomId, x.EquipmentId, x.ActivityId, x.PlaceId })
            .Select(g => new { g.Key.UserId, g.Key.RoomId, g.Key.EquipmentId, g.Key.ActivityId, g.Key.PlaceId, Count = g.Count() })
            .ToListAsync(cancellationToken);

        foreach (var view in views)
        {
            var score = view.Count switch
            {
                1 => InteractionWeights.SingleView,
                2 => InteractionWeights.RepeatedView,
                _ => InteractionWeights.FrequentView
            };

            Add(view.UserId, ItemKeys.From(view.RoomId, view.EquipmentId, view.ActivityId, view.PlaceId), score);
        }

        var favorites = await dbContext.Favorites.AsNoTracking()
            .Select(x => new { x.UserId, x.RoomId, x.EquipmentId, x.ActivityId, x.PlaceId })
            .ToListAsync(cancellationToken);

        foreach (var favorite in favorites)
        {
            Add(favorite.UserId, ItemKeys.From(favorite.RoomId, favorite.EquipmentId, favorite.ActivityId, favorite.PlaceId),
                InteractionWeights.Favorite);
        }

        var roomReservations = await dbContext.Set<RoomReservation>().AsNoTracking()
            .Where(x => CountedStatuses.Contains(x.Status))
            .Select(x => new { x.UserId, x.RoomId, x.Status })
            .ToListAsync(cancellationToken);

        foreach (var reservation in roomReservations)
        {
            Add(reservation.UserId, ItemKeys.From(ItemType.Room, reservation.RoomId), ReservationScore(reservation.Status));
        }

        var equipmentReservations = await dbContext.Set<EquipmentReservation>().AsNoTracking()
            .Where(x => CountedStatuses.Contains(x.Status))
            .Select(x => new { x.UserId, x.EquipmentId, x.Status })
            .ToListAsync(cancellationToken);

        foreach (var reservation in equipmentReservations)
        {
            Add(reservation.UserId, ItemKeys.From(ItemType.Equipment, reservation.EquipmentId), ReservationScore(reservation.Status));
        }

        var activityReservations = await dbContext.Set<ActivityReservation>().AsNoTracking()
            .Where(x => CountedStatuses.Contains(x.Status))
            .Select(x => new { x.UserId, x.ActivitySlot.ActivityId, x.Status })
            .ToListAsync(cancellationToken);

        foreach (var reservation in activityReservations)
        {
            Add(reservation.UserId, ItemKeys.From(ItemType.Activity, reservation.ActivityId), ReservationScore(reservation.Status));
        }

        var result = implicitScores.ToDictionary(
            x => x.Key,
            x => new UserItemScore(x.Key.UserId, x.Key.ItemKey, x.Value, IsExplicit: false));

        var reviews = await dbContext.Reviews.AsNoTracking()
            .Select(x => new { x.UserId, x.RoomId, x.EquipmentId, x.ActivityId, x.PlaceId, x.Rating })
            .ToListAsync(cancellationToken);

        foreach (var review in reviews)
        {
            var itemKey = ItemKeys.From(review.RoomId, review.EquipmentId, review.ActivityId, review.PlaceId);

            if (itemKey is not null)
            {
                result[(review.UserId, itemKey)] = new UserItemScore(review.UserId, itemKey, review.Rating, IsExplicit: true);
            }
        }

        return result.Values.ToList();
    }

    private static float ReservationScore(ReservationStatus status) =>
        status == ReservationStatus.Completed
            ? InteractionWeights.CompletedReservation
            : InteractionWeights.ConfirmedReservation;
}
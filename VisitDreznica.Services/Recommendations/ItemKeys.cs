using VisitDreznica.Model.Enums;

namespace VisitDreznica.Services.Recommendations;

public static class ItemKeys
{
    public static string From(ItemType type, int id) => $"{(int)type}:{id}";

    public static string? From(int? roomId, int? equipmentId, int? activityId, int? placeId) =>
        roomId.HasValue ? From(ItemType.Room, roomId.Value)
        : equipmentId.HasValue ? From(ItemType.Equipment, equipmentId.Value)
        : activityId.HasValue ? From(ItemType.Activity, activityId.Value)
        : placeId.HasValue ? From(ItemType.Place, placeId.Value)
        : null;
}
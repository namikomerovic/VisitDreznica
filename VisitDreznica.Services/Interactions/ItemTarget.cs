using System.Linq.Expressions;
using Microsoft.EntityFrameworkCore;
using VisitDreznica.Model.Enums;
using VisitDreznica.Model.Exceptions;
using VisitDreznica.Services.Database;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Interactions;

public static class ItemTargets
{
    public static Expression<Func<T, bool>> Matches<T>(ItemType type, int id) where T : class, IUserItemInteraction =>
        type switch
        {
            ItemType.Room => x => x.RoomId == id,
            ItemType.Equipment => x => x.EquipmentId == id,
            ItemType.Activity => x => x.ActivityId == id,
            ItemType.Place => x => x.PlaceId == id,
            _ => throw new BusinessException("Nepoznata vrsta stavke.")
        };

    public static Expression<Func<T, bool>> OfType<T>(ItemType type) where T : class, IUserItemInteraction =>
        type switch
        {
            ItemType.Room => x => x.RoomId != null,
            ItemType.Equipment => x => x.EquipmentId != null,
            ItemType.Activity => x => x.ActivityId != null,
            ItemType.Place => x => x.PlaceId != null,
            _ => throw new BusinessException("Nepoznata vrsta stavke.")
        };

    public static void Assign(IUserItemInteraction target, ItemType type, int id)
    {
        switch (type)
        {
            case ItemType.Room: target.RoomId = id; break;
            case ItemType.Equipment: target.EquipmentId = id; break;
            case ItemType.Activity: target.ActivityId = id; break;
            case ItemType.Place: target.PlaceId = id; break;
            default: throw new BusinessException("Nepoznata vrsta stavke.");
        }
    }

    public static async Task EnsureExistsAsync(VisitDreznicaDbContext dbContext, ItemType type, int id)
    {
        var exists = type switch
        {
            ItemType.Room => await dbContext.Set<Room>().AnyAsync(x => x.Id == id),
            ItemType.Equipment => await dbContext.Set<Equipment>().AnyAsync(x => x.Id == id),
            ItemType.Activity => await dbContext.Set<Activity>().AnyAsync(x => x.Id == id),
            ItemType.Place => await dbContext.Set<Place>().AnyAsync(x => x.Id == id),
            _ => false
        };

        if (!exists)
        {
            throw new NotFoundException("Tražena stavka ne postoji.");
        }
    }

    public static Task<bool> HasUsedAsync(VisitDreznicaDbContext dbContext, int userId, ItemType type, int id) =>
        type switch
        {
            ItemType.Room => dbContext.Set<RoomReservation>().AnyAsync(x =>
                x.UserId == userId && x.RoomId == id && x.Status == ReservationStatus.Completed),
            ItemType.Equipment => dbContext.Set<EquipmentReservation>().AnyAsync(x =>
                x.UserId == userId && x.EquipmentId == id && x.Status == ReservationStatus.Completed),
            ItemType.Activity => dbContext.Set<ActivityReservation>().AnyAsync(x =>
                x.UserId == userId && x.ActivitySlot.ActivityId == id && x.Status == ReservationStatus.Completed),
            ItemType.Place => Task.FromResult(true),
            _ => Task.FromResult(false)
        };
}
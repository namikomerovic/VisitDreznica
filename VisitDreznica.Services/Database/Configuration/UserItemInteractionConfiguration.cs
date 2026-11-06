using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Database.Configurations;

internal static class UserItemInteractionConfiguration
{
    private static readonly string[] TargetColumns =
    [
        nameof(IUserItemInteraction.RoomId),
        nameof(IUserItemInteraction.EquipmentId),
        nameof(IUserItemInteraction.ActivityId),
        nameof(IUserItemInteraction.PlaceId)
    ];

    public static void ConfigureItemTarget<T>(this EntityTypeBuilder<T> builder, bool uniquePerUser)
        where T : class, IUserItemInteraction
    {
        builder.HasOne<Room>(nameof(IUserItemInteraction.Room)).WithMany()
            .HasForeignKey(nameof(IUserItemInteraction.RoomId)).OnDelete(DeleteBehavior.Restrict);

        builder.HasOne<Equipment>(nameof(IUserItemInteraction.Equipment)).WithMany()
            .HasForeignKey(nameof(IUserItemInteraction.EquipmentId)).OnDelete(DeleteBehavior.Restrict);

        builder.HasOne<Activity>(nameof(IUserItemInteraction.Activity)).WithMany()
            .HasForeignKey(nameof(IUserItemInteraction.ActivityId)).OnDelete(DeleteBehavior.Restrict);

        builder.HasOne<Place>(nameof(IUserItemInteraction.Place)).WithMany()
            .HasForeignKey(nameof(IUserItemInteraction.PlaceId)).OnDelete(DeleteBehavior.Restrict);

        var exactlyOneTarget = string.Join(" + ",
            TargetColumns.Select(column => $"CASE WHEN [{column}] IS NULL THEN 0 ELSE 1 END"));

        builder.ToTable(table => table.HasCheckConstraint(
            $"CK_{typeof(T).Name}_SingleTarget", $"({exactlyOneTarget}) = 1"));

        if (!uniquePerUser)
        {
            return;
        }

        foreach (var column in TargetColumns)
        {
            builder.HasIndex(nameof(IUserItemInteraction.UserId), column)
                .IsUnique()
                .HasFilter($"[{column}] IS NOT NULL");
        }
    }
}
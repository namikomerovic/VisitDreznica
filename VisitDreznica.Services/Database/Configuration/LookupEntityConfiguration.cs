using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Database.Configurations;

public abstract class LookupEntityConfiguration<TEntity> : IEntityTypeConfiguration<TEntity>
    where TEntity : LookupEntity
{
    public virtual void Configure(EntityTypeBuilder<TEntity> builder)
    {
        builder.Property(x => x.Name).IsRequired().HasMaxLength(100);
        builder.Property(x => x.Description).HasMaxLength(300);
        builder.HasIndex(x => x.Name).IsUnique();
    }
}

public class RoomTypeConfiguration : LookupEntityConfiguration<RoomType>;

public class AmenityConfiguration : LookupEntityConfiguration<Amenity>;

public class EquipmentTypeConfiguration : LookupEntityConfiguration<EquipmentType>;

public class ActivityCategoryConfiguration : LookupEntityConfiguration<ActivityCategory>;

public class PlaceTypeConfiguration : LookupEntityConfiguration<PlaceType>;
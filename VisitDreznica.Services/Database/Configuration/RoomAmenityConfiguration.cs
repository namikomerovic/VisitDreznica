using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Database.Configurations;

public class RoomAmenityConfiguration : IEntityTypeConfiguration<RoomAmenity>
{
    public void Configure(EntityTypeBuilder<RoomAmenity> builder)
    {
        builder.HasKey(x => new { x.RoomId, x.AmenityId });

        builder.HasOne(x => x.Room)
            .WithMany(x => x.RoomAmenities)
            .HasForeignKey(x => x.RoomId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasOne(x => x.Amenity)
            .WithMany()
            .HasForeignKey(x => x.AmenityId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
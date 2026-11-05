using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Database.Configurations;

public class PlaceConfiguration : IEntityTypeConfiguration<Place>
{
    public void Configure(EntityTypeBuilder<Place> builder)
    {
        builder.Property(x => x.Name).IsRequired().HasMaxLength(150);
        builder.Property(x => x.Description).HasMaxLength(2000);
        builder.Property(x => x.Address).HasMaxLength(200);
        builder.Property(x => x.Latitude).HasPrecision(9, 6);
        builder.Property(x => x.Longitude).HasPrecision(9, 6);
        builder.Property(x => x.DistanceKm).HasPrecision(6, 2);
        builder.HasIndex(x => x.Name).IsUnique();

        builder.HasOne(x => x.PlaceType)
            .WithMany()
            .HasForeignKey(x => x.PlaceTypeId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
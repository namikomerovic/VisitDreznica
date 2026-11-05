using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Database.Configurations;

public class RoomConfiguration : IEntityTypeConfiguration<Room>
{
    public void Configure(EntityTypeBuilder<Room> builder)
    {
        builder.Property(x => x.Name).IsRequired().HasMaxLength(100);
        builder.Property(x => x.Description).HasMaxLength(1000);
        builder.Property(x => x.PricePerNight).HasPrecision(10, 2);
        builder.HasIndex(x => x.Name).IsUnique();

        builder.HasOne(x => x.RoomType)
            .WithMany()
            .HasForeignKey(x => x.RoomTypeId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
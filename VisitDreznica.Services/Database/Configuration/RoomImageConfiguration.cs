using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Database.Configurations;

public class RoomImageConfiguration : IEntityTypeConfiguration<RoomImage>
{
    public void Configure(EntityTypeBuilder<RoomImage> builder)
    {
        builder.Property(x => x.Data).IsRequired();
        builder.Property(x => x.ContentType).IsRequired().HasMaxLength(50);

        builder.HasOne(x => x.Room)
            .WithMany(x => x.Images)
            .HasForeignKey(x => x.RoomId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
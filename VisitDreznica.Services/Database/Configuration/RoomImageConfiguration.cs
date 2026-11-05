using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Database.Configurations;

public class RoomImageConfiguration : GalleryImageConfiguration<RoomImage>
{
    public override void Configure(EntityTypeBuilder<RoomImage> builder)
    {
        base.Configure(builder);

        builder.Property(x => x.OwnerId).HasColumnName("RoomId");

        builder.HasOne(x => x.Room)
            .WithMany(x => x.Images)
            .HasForeignKey(x => x.OwnerId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
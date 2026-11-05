using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Database.Configurations;

public class PlaceImageConfiguration : GalleryImageConfiguration<PlaceImage>
{
    public override void Configure(EntityTypeBuilder<PlaceImage> builder)
    {
        base.Configure(builder);

        builder.Property(x => x.OwnerId).HasColumnName("PlaceId");

        builder.HasOne(x => x.Place)
            .WithMany(x => x.Images)
            .HasForeignKey(x => x.OwnerId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
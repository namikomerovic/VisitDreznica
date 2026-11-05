using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Database.Configurations;

public abstract class GalleryImageConfiguration<TImage> : IEntityTypeConfiguration<TImage>
    where TImage : GalleryImage
{
    public virtual void Configure(EntityTypeBuilder<TImage> builder)
    {
        builder.Property(x => x.Data).IsRequired();
        builder.Property(x => x.ContentType).IsRequired().HasMaxLength(50);
    }
}
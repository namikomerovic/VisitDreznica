using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Database.Configurations;

public class NewsConfiguration : IEntityTypeConfiguration<News>
{
    public void Configure(EntityTypeBuilder<News> builder)
    {
        builder.Property(x => x.Title).IsRequired().HasMaxLength(150);
        builder.Property(x => x.Content).IsRequired().HasMaxLength(4000);
        builder.Property(x => x.ImageContentType).HasMaxLength(50);
        builder.HasIndex(x => x.PublishedAt);

        builder.HasOne(x => x.CreatedByUser)
            .WithMany()
            .HasForeignKey(x => x.CreatedByUserId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Database.Configurations;

public class ActivityConfiguration : IEntityTypeConfiguration<Activity>
{
    public void Configure(EntityTypeBuilder<Activity> builder)
    {
        builder.Property(x => x.Name).IsRequired().HasMaxLength(150);
        builder.Property(x => x.Description).HasMaxLength(2000);
        builder.Property(x => x.MeetingPoint).HasMaxLength(200);
        builder.Property(x => x.PricePerPerson).HasPrecision(10, 2);
        builder.Property(x => x.ImageContentType).HasMaxLength(50);
        builder.HasIndex(x => x.Name).IsUnique();

        builder.HasOne(x => x.ActivityCategory)
            .WithMany()
            .HasForeignKey(x => x.ActivityCategoryId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Database.Configurations;

public class ActivitySlotConfiguration : IEntityTypeConfiguration<ActivitySlot>
{
    public void Configure(EntityTypeBuilder<ActivitySlot> builder)
    {
        builder.HasOne(x => x.Activity)
            .WithMany(x => x.Slots)
            .HasForeignKey(x => x.ActivityId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasOne(x => x.Guide)
            .WithMany()
            .HasForeignKey(x => x.GuideId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasIndex(x => new { x.ActivityId, x.StartTime });
        builder.HasIndex(x => new { x.GuideId, x.StartTime });
    }
}
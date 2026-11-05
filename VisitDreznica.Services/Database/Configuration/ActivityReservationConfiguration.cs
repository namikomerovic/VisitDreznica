using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Database.Configurations;

public class ActivityReservationConfiguration : IEntityTypeConfiguration<ActivityReservation>
{
    public void Configure(EntityTypeBuilder<ActivityReservation> builder)
    {
        builder.ToTable("ActivityReservations");

        builder.HasOne(x => x.ActivitySlot)
            .WithMany()
            .HasForeignKey(x => x.ActivitySlotId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasIndex(x => x.ActivitySlotId);
    }
}
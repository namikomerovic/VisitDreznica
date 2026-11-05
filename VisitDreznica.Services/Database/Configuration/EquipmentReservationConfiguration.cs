using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Database.Configurations;

public class EquipmentReservationConfiguration : IEntityTypeConfiguration<EquipmentReservation>
{
    public void Configure(EntityTypeBuilder<EquipmentReservation> builder)
    {
        builder.ToTable("EquipmentReservations");

        builder.HasOne(x => x.Equipment)
            .WithMany()
            .HasForeignKey(x => x.EquipmentId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasIndex(x => x.EquipmentId);
    }
}
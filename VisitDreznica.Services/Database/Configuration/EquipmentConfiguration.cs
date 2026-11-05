using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Database.Configurations;

public class EquipmentConfiguration : IEntityTypeConfiguration<Equipment>
{
    public void Configure(EntityTypeBuilder<Equipment> builder)
    {
        builder.Property(x => x.Name).IsRequired().HasMaxLength(100);
        builder.Property(x => x.Description).HasMaxLength(1000);
        builder.Property(x => x.FirstHourPrice).HasPrecision(10, 2);
        builder.Property(x => x.AdditionalHourPrice).HasPrecision(10, 2);
        builder.Property(x => x.FullDayPrice).HasPrecision(10, 2);
        builder.Property(x => x.ImageContentType).HasMaxLength(50);
        builder.HasIndex(x => x.Name).IsUnique();

        builder.HasOne(x => x.EquipmentType)
            .WithMany()
            .HasForeignKey(x => x.EquipmentTypeId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
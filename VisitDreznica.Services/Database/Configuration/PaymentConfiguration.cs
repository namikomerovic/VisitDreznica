using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Database.Configurations;

public class PaymentConfiguration : IEntityTypeConfiguration<Payment>
{
    public void Configure(EntityTypeBuilder<Payment> builder)
    {
        builder.Property(x => x.StripePaymentIntentId).IsRequired().HasMaxLength(100);
        builder.Property(x => x.Currency).IsRequired().HasMaxLength(3);
        builder.Property(x => x.Amount).HasPrecision(10, 2);
        builder.HasIndex(x => x.StripePaymentIntentId).IsUnique();

        builder.HasOne(x => x.Reservation)
            .WithMany(x => x.Payments)
            .HasForeignKey(x => x.ReservationId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
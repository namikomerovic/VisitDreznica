using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Database.Configurations;

public class RefundConfiguration : IEntityTypeConfiguration<Refund>
{
    public void Configure(EntityTypeBuilder<Refund> builder)
    {
        builder.Property(x => x.StripeRefundId).IsRequired().HasMaxLength(100);
        builder.Property(x => x.Amount).HasPrecision(10, 2);
        builder.Property(x => x.Reason).HasMaxLength(500);
        builder.HasIndex(x => x.StripeRefundId).IsUnique();

        builder.HasOne(x => x.Payment)
            .WithMany(x => x.Refunds)
            .HasForeignKey(x => x.PaymentId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
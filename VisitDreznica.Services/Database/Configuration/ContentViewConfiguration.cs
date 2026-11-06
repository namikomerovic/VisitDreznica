using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Database.Configurations;

public class ContentViewConfiguration : IEntityTypeConfiguration<ContentView>
{
    public void Configure(EntityTypeBuilder<ContentView> builder)
    {
        builder.HasOne(x => x.User)
            .WithMany()
            .HasForeignKey(x => x.UserId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasIndex(x => new { x.UserId, x.ViewedAt });

        builder.ConfigureItemTarget(uniquePerUser: false);
    }
}
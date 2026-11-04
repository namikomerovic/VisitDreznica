using Microsoft.EntityFrameworkCore;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Database;

public class VisitDreznicaDbContext(DbContextOptions<VisitDreznicaDbContext> options) : DbContext(options)
{
    public DbSet<Country> Countries => Set<Country>();
    public DbSet<City> Cities => Set<City>();
    public DbSet<Role> Roles => Set<Role>();
    public DbSet<User> Users => Set<User>();
    public DbSet<UserRole> UserRoles => Set<UserRole>();
    public DbSet<UserSession> UserSessions => Set<UserSession>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(VisitDreznicaDbContext).Assembly);
    }
}
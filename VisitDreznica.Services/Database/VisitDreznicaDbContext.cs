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
    public DbSet<RoomType> RoomTypes => Set<RoomType>();
    public DbSet<Amenity> Amenities => Set<Amenity>();
    public DbSet<EquipmentType> EquipmentTypes => Set<EquipmentType>();
    public DbSet<ActivityCategory> ActivityCategories => Set<ActivityCategory>();
    public DbSet<PlaceType> PlaceTypes => Set<PlaceType>();
    public DbSet<Guide> Guides => Set<Guide>();
    public DbSet<Room> Rooms => Set<Room>();
    public DbSet<RoomImage> RoomImages => Set<RoomImage>();
    public DbSet<RoomAmenity> RoomAmenities => Set<RoomAmenity>();
    public DbSet<Equipment> Equipment => Set<Equipment>();
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(VisitDreznicaDbContext).Assembly);
    }
}
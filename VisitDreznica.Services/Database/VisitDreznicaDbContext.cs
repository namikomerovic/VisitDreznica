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
    public DbSet<Activity> Activities => Set<Activity>();
    public DbSet<ActivitySlot> ActivitySlots => Set<ActivitySlot>();
    public DbSet<Place> Places => Set<Place>();
    public DbSet<PlaceImage> PlaceImages => Set<PlaceImage>();
    public DbSet<News> News => Set<News>();
    public DbSet<Reservation> Reservations => Set<Reservation>();
    public DbSet<RoomReservation> RoomReservations => Set<RoomReservation>();
    public DbSet<EquipmentReservation> EquipmentReservations => Set<EquipmentReservation>();
    public DbSet<ActivityReservation> ActivityReservations => Set<ActivityReservation>();
    public DbSet<ReservationStatusHistory> ReservationStatusHistory => Set<ReservationStatusHistory>();
    public DbSet<Payment> Payments => Set<Payment>();
    public DbSet<Refund> Refunds => Set<Refund>();
    public DbSet<Review> Reviews => Set<Review>();
    public DbSet<Favorite> Favorites => Set<Favorite>();
    public DbSet<ContentView> ContentViews => Set<ContentView>();
    public DbSet<Notification> Notifications => Set<Notification>();
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(VisitDreznicaDbContext).Assembly);
    }

    protected override void ConfigureConventions(ModelConfigurationBuilder configurationBuilder)
    {
        configurationBuilder.Properties<DateTime>().HaveConversion<UtcDateTimeConverter>();
        configurationBuilder.Properties<DateTime?>().HaveConversion<NullableUtcDateTimeConverter>();
    }
}
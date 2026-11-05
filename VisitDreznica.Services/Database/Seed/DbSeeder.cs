using Microsoft.EntityFrameworkCore;
using VisitDreznica.Model.Constants;
using VisitDreznica.Services.Database.Entities;
using VisitDreznica.Services.Security;

namespace VisitDreznica.Services.Database.Seed;

public class DbSeeder(VisitDreznicaDbContext dbContext, IPasswordHasher passwordHasher)
{
    private const string DefaultPassword = "test";

    public async Task SeedAsync()
    {
        await SeedUsersAndLocationsAsync();
        await SeedLookupsAsync();
    }

    private async Task SeedUsersAndLocationsAsync()
    {
        if (await dbContext.Roles.AnyAsync())
        {
            return;
        }

        var adminRole = new Role { Name = AppRoles.Admin, Description = "Administrator smještaja" };
        var guestRole = new Role { Name = AppRoles.Guest, Description = "Gost" };

        var mostar = new City { Name = "Mostar", PostalCode = "88000" };
        var jablanica = new City { Name = "Jablanica", PostalCode = "88420" };
        var konjic = new City { Name = "Konjic", PostalCode = "88400" };
        var sarajevo = new City { Name = "Sarajevo", PostalCode = "71000" };
        var zenica = new City { Name = "Zenica", PostalCode = "72000" };
        var tuzla = new City { Name = "Tuzla", PostalCode = "75000" };
        var banjaLuka = new City { Name = "Banja Luka", PostalCode = "78000" };
        var zagreb = new City { Name = "Zagreb", PostalCode = "10000" };
        var split = new City { Name = "Split", PostalCode = "21000" };
        var beograd = new City { Name = "Beograd", PostalCode = "11000" };
        var podgorica = new City { Name = "Podgorica", PostalCode = "81000" };
        var ljubljana = new City { Name = "Ljubljana", PostalCode = "1000" };
        var bec = new City { Name = "Beč", PostalCode = "1010" };
        var minhen = new City { Name = "Minhen", PostalCode = "80331" };

        var countries = new List<Country>
        {
            new() { Name = "Bosna i Hercegovina", Cities = { mostar, jablanica, konjic, sarajevo, zenica, tuzla, banjaLuka } },
            new() { Name = "Hrvatska", Cities = { zagreb, split } },
            new() { Name = "Srbija", Cities = { beograd } },
            new() { Name = "Crna Gora", Cities = { podgorica } },
            new() { Name = "Slovenija", Cities = { ljubljana } },
            new() { Name = "Austrija", Cities = { bec } },
            new() { Name = "Njemačka", Cities = { minhen } }
        };

        var users = new List<User>
        {
            CreateUser("Amra", "Jelić", "desktop", "desktop@visitdreznica.ba", "061 100 200", jablanica, adminRole),
            CreateUser("Amar", "Hodžić", "mobile", "mobile@visitdreznica.ba", "061 234 567", sarajevo, guestRole),
            CreateUser("Lejla", "Kovač", "lejla.kovac", "lejla.kovac@mail.ba", "062 345 678", mostar, guestRole),
            CreateUser("Tarik", "Begić", "tarik.begic", "tarik.begic@mail.ba", "061 987 654", zenica, guestRole),
            CreateUser("Emina", "Mehić", "emina.mehic", "emina.mehic@mail.ba", "063 111 222", tuzla, guestRole),
            CreateUser("Sara", "Marić", "sara.maric", "sara.maric@mail.hr", "+385 91 222 333", split, guestRole)
        };

        dbContext.Roles.AddRange(adminRole, guestRole);
        dbContext.Countries.AddRange(countries);
        dbContext.Users.AddRange(users);

        await dbContext.SaveChangesAsync();
    }

    private async Task SeedLookupsAsync()
    {
        if (await dbContext.RoomTypes.AnyAsync())
        {
            return;
        }

        dbContext.RoomTypes.AddRange(
            new RoomType { Name = "Jednokrevetna", Description = "Soba za jednu osobu" },
            new RoomType { Name = "Dvokrevetna", Description = "Bračni ili dva odvojena kreveta" },
            new RoomType { Name = "Trokrevetna", Description = "Soba za tri osobe" },
            new RoomType { Name = "Porodična", Description = "Soba za četiri i više osoba" });

        dbContext.Amenities.AddRange(
            new Amenity { Name = "Balkon" },
            new Amenity { Name = "Klima uređaj" },
            new Amenity { Name = "Vlastito kupatilo" },
            new Amenity { Name = "Pogled na rijeku" },
            new Amenity { Name = "TV" },
            new Amenity { Name = "Kuhalo za vodu" },
            new Amenity { Name = "Besplatan Wi-Fi" });

        dbContext.EquipmentTypes.AddRange(
            new EquipmentType { Name = "Kajak", Description = "Kajaci za jednu ili dvije osobe" },
            new EquipmentType { Name = "Kanu", Description = "Otvoreni kanu za mirnije vode" },
            new EquipmentType { Name = "SUP daska", Description = "Daska za veslanje stojeći" });

        dbContext.ActivityCategories.AddRange(
            new ActivityCategory { Name = "Na vodi", Description = "Splavarenje i vožnje rijekom" },
            new ActivityCategory { Name = "Planinarenje", Description = "Pješačke ture kanjonima i planinama" },
            new ActivityCategory { Name = "Ribolov", Description = "Ribolov uz vodiča" },
            new ActivityCategory { Name = "Kultura", Description = "Historijske i kulturne ture" });

        dbContext.PlaceTypes.AddRange(
            new PlaceType { Name = "Plaža", Description = "Plaže na rijekama" },
            new PlaceType { Name = "Priroda", Description = "Izvori, vidikovci i prirodne ljepote" },
            new PlaceType { Name = "Znamenitost", Description = "Historijske znamenitosti" });

        dbContext.Guides.AddRange(
            new Guide { FirstName = "Kenan", LastName = "Hadžić", PhoneNumber = "061 555 111" },
            new Guide { FirstName = "Adnan", LastName = "Ćorić", PhoneNumber = "062 555 222" });

        await dbContext.SaveChangesAsync();
    }

    private User CreateUser(string firstName, string lastName, string username, string email,
        string phoneNumber, City city, Role role)
    {
        var (hash, salt) = passwordHasher.HashPassword(DefaultPassword);

        var user = new User
        {
            FirstName = firstName,
            LastName = lastName,
            Username = username,
            Email = email,
            PhoneNumber = phoneNumber,
            City = city,
            PasswordHash = hash,
            PasswordSalt = salt,
            IsActive = true,
            CreatedAt = DateTime.UtcNow
        };

        user.UserRoles.Add(new UserRole { Role = role });

        return user;
    }
}
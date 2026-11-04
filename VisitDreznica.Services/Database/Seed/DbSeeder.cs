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
        if (await dbContext.Roles.AnyAsync())
        {
            return;
        }

        // ---------- Uloge ----------
        var adminRole = new Role { Name = AppRoles.Admin, Description = "Administrator smještaja" };
        var guestRole = new Role { Name = AppRoles.Guest, Description = "Gost" };

        // ---------- Gradovi ----------
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

        // ---------- Države ----------
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

        // ---------- Korisnici ----------
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
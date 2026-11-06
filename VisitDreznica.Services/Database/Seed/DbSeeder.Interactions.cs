using Microsoft.EntityFrameworkCore;
using VisitDreznica.Model.Constants;
using VisitDreznica.Model.Enums;
using VisitDreznica.Services.Database.Entities;
using VisitDreznica.Services.Interactions;

namespace VisitDreznica.Services.Database.Seed;

public partial class DbSeeder
{
    private const string InteractionSeedMarker = "ajla.hasic";
    private const int InteractionSeedRandomSeed = 2026;
    private const decimal SeedTouristTaxPerPersonNight = 2m;
    private const string SeedCurrency = "bam";

    private sealed record Persona(string Name, int MinGuests, int MaxGuests, Dictionary<string, int> Affinity);

    private sealed record SeedGuest(string FirstName, string LastName, string City, Persona Persona, string? ExistingUsername = null);

    private sealed record UsedItem(ItemType Type, int Id, string Name, DateTime UsedAt);

    private sealed class SlotUsage(ActivitySlot slot)
    {
        public ActivitySlot Slot { get; } = slot;
        public int Booked { get; set; }
    }

    private static readonly Persona Adventurers = new("Avanturisti", 1, 2, new()
    {
        ["Jednokrevetna soba"] = 4,
        ["Dvokrevetna soba s pogledom na jezero"] = 3,
        ["Kajak jednosjed"] = 5,
        ["Kajak dvosjed"] = 4,
        ["Vožnja splavom kanjonom Neretve"] = 5,
        ["Pješačka tura kanjonom Drežanke"] = 4,
        ["Ribolov na Neretvi s vodičem"] = 3,
        ["Historijska tura do Jablanice"] = 1,
        ["Vrelo Drežanke"] = 4,
        ["Plaža na ušću Drežanke"] = 3,
        ["Plaža Grabovica"] = 3,
        ["Željeznički most u Drežnici"] = 2,
        ["Srušeni most na Neretvi"] = 2
    });

    private static readonly Persona RiverRelaxers = new("Odmor uz rijeku", 2, 2, new()
    {
        ["Deluxe dvokrevetna soba s balkonom"] = 5,
        ["Dvokrevetna soba s pogledom na jezero"] = 5,
        ["Kajak jednosjed"] = 2,
        ["Kajak dvosjed"] = 4,
        ["Vožnja splavom kanjonom Neretve"] = 3,
        ["Pješačka tura kanjonom Drežanke"] = 1,
        ["Ribolov na Neretvi s vodičem"] = 2,
        ["Historijska tura do Jablanice"] = 2,
        ["Plaža na ušću Drežanke"] = 5,
        ["Plaža Grabovica"] = 5,
        ["Vrelo Drežanke"] = 3,
        ["Željeznički most u Drežnici"] = 3,
        ["Srušeni most na Neretvi"] = 2
    });

    private static readonly Persona NatureAndHistory = new("Priroda i historija", 1, 2, new()
    {
        ["Dvokrevetna soba s pogledom na jezero"] = 4,
        ["Deluxe dvokrevetna soba s balkonom"] = 3,
        ["Jednokrevetna soba"] = 3,
        ["Kajak jednosjed"] = 2,
        ["Kajak dvosjed"] = 2,
        ["Vožnja splavom kanjonom Neretve"] = 2,
        ["Pješačka tura kanjonom Drežanke"] = 5,
        ["Ribolov na Neretvi s vodičem"] = 4,
        ["Historijska tura do Jablanice"] = 5,
        ["Vrelo Drežanke"] = 5,
        ["Željeznički most u Drežnici"] = 5,
        ["Srušeni most na Neretvi"] = 5,
        ["Plaža na ušću Drežanke"] = 2,
        ["Plaža Grabovica"] = 2
    });

    private static readonly Persona Families = new("Porodice", 3, 4, new()
    {
        ["Četverokrevetna soba s balkonom"] = 5,
        ["Trokrevetna soba s pogledom na planinu"] = 4,
        ["Kajak jednosjed"] = 2,
        ["Kajak dvosjed"] = 5,
        ["Vožnja splavom kanjonom Neretve"] = 3,
        ["Pješačka tura kanjonom Drežanke"] = 2,
        ["Ribolov na Neretvi s vodičem"] = 2,
        ["Historijska tura do Jablanice"] = 3,
        ["Plaža na ušću Drežanke"] = 5,
        ["Plaža Grabovica"] = 4,
        ["Vrelo Drežanke"] = 3,
        ["Željeznički most u Drežnici"] = 3,
        ["Srušeni most na Neretvi"] = 3
    });

    private static readonly SeedGuest[] SeedGuests =
    [
        new("Ajla", "Hasić", "Sarajevo", Adventurers),
        new("Selma", "Imamović", "Tuzla", RiverRelaxers),
        new("Haris", "Delić", "Mostar", NatureAndHistory),
        new("Adis", "Smajić", "Banja Luka", Families),
        new("Dino", "Mujić", "Zenica", Adventurers),
        new("Ivana", "Perić", "Split", RiverRelaxers),
        new("Edin", "Karić", "Konjic", NatureAndHistory),
        new("Lana", "Babić", "Sarajevo", Families),
        new("Luka", "Novak", "Zagreb", Adventurers),
        new("Marko", "Jovanović", "Beograd", RiverRelaxers),
        new("Milica", "Vuković", "Podgorica", NatureAndHistory),
        new("Mirza", "Šehić", "Mostar", Families),
        new("Jan", "Kranjc", "Ljubljana", Adventurers),
        new("Nina", "Gruber", "Beč", RiverRelaxers),
        new("Thomas", "Weber", "Minhen", NatureAndHistory),
        new("Petra", "Horvat", "Zagreb", Families),
        new("Lejla", "Kovač", "Mostar", Adventurers, "lejla.kovac"),
        new("Sara", "Marić", "Split", RiverRelaxers, "sara.maric"),
        new("Tarik", "Begić", "Zenica", NatureAndHistory, "tarik.begic"),
        new("Emina", "Mehić", "Tuzla", Families, "emina.mehic")
    ];

    private static readonly Dictionary<int, string[]> SeedComments = new()
    {
        [5] = ["Odlično iskustvo, svima preporučujem!", "Savršeno, sigurno se vraćamo.", "Nezaboravno, sve pohvale domaćinima.", "Bolje od očekivanja!"],
        [4] = ["Vrlo dobro, uživali smo.", "Lijepo iskustvo, uz sitne zamjerke.", "Dobar omjer cijene i kvalitete."],
        [3] = ["Solidno, ali očekivali smo više.", "U redu, ništa posebno."],
        [2] = ["Nije baš za nas.", "Moglo je bolje."],
        [1] = ["Razočarani smo.", "Ne bismo ponovili."]
    };

    private async Task SeedInteractionsAsync()
    {
        if (await dbContext.Users.AnyAsync(x => x.Username == InteractionSeedMarker))
        {
            return;
        }

        var rng = new Random(InteractionSeedRandomSeed);
        var now = DateTime.UtcNow;
        var today = now.Date;

        var guestRole = await dbContext.Roles.FirstAsync(x => x.Name == AppRoles.Guest);
        var admin = await dbContext.Users.FirstAsync(x => x.Username == "desktop");
        var cities = await dbContext.Cities.ToDictionaryAsync(x => x.Name);
        var kenan = await dbContext.Guides.FirstAsync(x => x.FirstName == "Kenan");
        var adnan = await dbContext.Guides.FirstAsync(x => x.FirstName == "Adnan");

        var rooms = await dbContext.Rooms.Where(x => x.IsActive).OrderBy(x => x.Id).ToListAsync();
        var equipment = await dbContext.Equipment.Where(x => x.IsActive).OrderBy(x => x.Id).ToListAsync();
        var activities = await dbContext.Activities.OrderBy(x => x.Id).ToListAsync();
        var places = await dbContext.Places.Where(x => x.IsActive).OrderBy(x => x.Id).ToListAsync();

        var catalog = rooms.Select(x => (Type: ItemType.Room, x.Id))
            .Concat(equipment.Select(x => (Type: ItemType.Equipment, x.Id)))
            .Concat(activities.Select(x => (Type: ItemType.Activity, x.Id)))
            .Concat(places.Select(x => (Type: ItemType.Place, x.Id)))
            .ToList();

        var roomCalendar = rooms.ToDictionary(x => x.Id, _ => today.AddDays(-330));
        var slots = new Dictionary<(int ActivityId, DateTime Day), SlotUsage>();

        foreach (var seedGuest in SeedGuests)
        {
            var guest = await GetOrCreateSeedGuestAsync(seedGuest, cities, guestRole, rng);

            if (guest is null)
            {
                continue;
            }

            var persona = seedGuest.Persona;
            int Affinity(string name) => persona.Affinity.GetValueOrDefault(name, 2);

            var guestCount = rng.Next(persona.MinGuests, persona.MaxGuests + 1);
            var roomOptions = rooms.Where(x => x.Capacity >= guestCount).ToList();

            if (roomOptions.Count == 0)
            {
                continue;
            }

            var room = PickWeighted(rng, roomOptions, x => Math.Pow(Affinity(x.Name), 3));
            var nights = rng.Next(2, 5);
            var checkIn = roomCalendar[room.Id];
            roomCalendar[room.Id] = checkIn.AddDays(nights + rng.Next(1, 7));

            var bookedAt = checkIn.AddDays(-rng.Next(5, 40)).AddHours(rng.Next(8, 20));

            var stay = new RoomReservation
            {
                Room = room,
                GuestCount = guestCount,
                StartTime = checkIn.AddHours(12),
                EndTime = checkIn.AddDays(nights).AddHours(8),
                TotalPrice = nights * room.PricePerNight + nights * guestCount * SeedTouristTaxPerPersonNight
            };

            AddCompletedReservation(stay, guest, admin, bookedAt);

            var used = new List<UsedItem> { new(ItemType.Room, room.Id, room.Name, stay.EndTime) };

            foreach (var activity in activities)
            {
                if (rng.NextDouble() >= UseProbability(Affinity(activity.Name)))
                {
                    continue;
                }

                var day = checkIn.AddDays(rng.Next(0, nights));
                var guide = activity.Name.Contains("splav") ? kenan : adnan;
                var usage = GetOrCreateSeedSlot(slots, activity, day, guide, bookedAt);

                if (usage.Booked + guestCount > usage.Slot.Capacity)
                {
                    continue;
                }

                usage.Booked += guestCount;

                var reservation = new ActivityReservation
                {
                    ActivitySlot = usage.Slot,
                    ParticipantCount = guestCount,
                    StartTime = usage.Slot.StartTime,
                    EndTime = usage.Slot.EndTime,
                    TotalPrice = activity.PricePerPerson * guestCount
                };

                AddCompletedReservation(reservation, guest, admin, bookedAt.AddMinutes(rng.Next(5, 60)));
                used.Add(new UsedItem(ItemType.Activity, activity.Id, activity.Name, usage.Slot.EndTime));
            }

            foreach (var item in equipment)
            {
                if (rng.NextDouble() >= UseProbability(Affinity(item.Name)))
                {
                    continue;
                }

                var hours = rng.Next(1, 5);
                var quantity = (int)Math.Ceiling(guestCount / (double)item.Capacity);
                var start = checkIn.AddDays(rng.Next(0, nights)).AddHours(9 + rng.Next(0, 4));
                var hourlyTotal = item.FirstHourPrice + item.AdditionalHourPrice * (hours - 1);

                var reservation = new EquipmentReservation
                {
                    Equipment = item,
                    Quantity = quantity,
                    StartTime = start,
                    EndTime = start.AddHours(hours),
                    TotalPrice = quantity * Math.Min(hourlyTotal, item.FullDayPrice)
                };

                AddCompletedReservation(reservation, guest, admin, bookedAt.AddMinutes(rng.Next(5, 60)));
                used.Add(new UsedItem(ItemType.Equipment, item.Id, item.Name, reservation.EndTime));
            }

            foreach (var place in places)
            {
                if (rng.NextDouble() < UseProbability(Affinity(place.Name)))
                {
                    var visitedAt = checkIn.AddDays(rng.Next(0, nights)).AddHours(14);
                    used.Add(new UsedItem(ItemType.Place, place.Id, place.Name, visitedAt));
                }
            }

            foreach (var item in used)
            {
                var rating = SeedRating(rng, Affinity(item.Name));

                AddSeedViews(guest, item.Type, item.Id, rng.Next(1, 4), bookedAt, rng);

                if (rng.NextDouble() < (item.Type == ItemType.Place ? 0.6 : 0.8))
                {
                    var review = new Review
                    {
                        User = guest,
                        Rating = rating,
                        Comment = SeedComment(rng, rating),
                        CreatedAt = item.UsedAt.AddDays(1)
                    };

                    ItemTargets.Assign(review, item.Type, item.Id);
                    dbContext.Reviews.Add(review);
                }

                if (rating == 5 && rng.NextDouble() < 0.5)
                {
                    var favorite = new Favorite { User = guest, CreatedAt = item.UsedAt.AddDays(1) };
                    ItemTargets.Assign(favorite, item.Type, item.Id);
                    dbContext.Favorites.Add(favorite);
                }
            }

            var browsed = catalog
                .Where(x => !used.Any(u => u.Type == x.Type && u.Id == x.Id))
                .OrderBy(_ => rng.Next())
                .Take(2)
                .ToList();

            foreach (var item in browsed)
            {
                AddSeedViews(guest, item.Type, item.Id, 1, bookedAt, rng);
            }
        }

        await dbContext.SaveChangesAsync();
    }

    private async Task<User?> GetOrCreateSeedGuestAsync(SeedGuest seedGuest, Dictionary<string, City> cities, Role guestRole, Random rng)
    {
        if (seedGuest.ExistingUsername is not null)
        {
            return await dbContext.Users.FirstOrDefaultAsync(x => x.Username == seedGuest.ExistingUsername);
        }

        if (!cities.TryGetValue(seedGuest.City, out var city))
        {
            return null;
        }

        var username = ToSeedUsername(seedGuest.FirstName, seedGuest.LastName);
        var phone = $"06{rng.Next(1, 4)} {rng.Next(100, 1000)} {rng.Next(100, 1000)}";

        var user = CreateUser(seedGuest.FirstName, seedGuest.LastName, username, $"{username}@mail.ba", phone, city, guestRole);
        dbContext.Users.Add(user);

        return user;
    }

    private void AddCompletedReservation(Reservation reservation, User guest, User admin, DateTime bookedAt)
    {
        reservation.User = guest;
        reservation.Status = ReservationStatus.Completed;
        reservation.CreatedAt = bookedAt;
        reservation.UpdatedAt = reservation.EndTime.AddHours(2);

        reservation.StatusHistory.Add(new ReservationStatusHistory
        {
            FromStatus = null,
            ToStatus = ReservationStatus.Pending,
            ChangedByUser = guest,
            ChangedAt = bookedAt
        });

        reservation.StatusHistory.Add(new ReservationStatusHistory
        {
            FromStatus = ReservationStatus.Pending,
            ToStatus = ReservationStatus.Confirmed,
            ChangedByUser = admin,
            ChangedAt = bookedAt.AddHours(2)
        });

        reservation.StatusHistory.Add(new ReservationStatusHistory
        {
            FromStatus = ReservationStatus.Confirmed,
            ToStatus = ReservationStatus.Completed,
            ChangedByUser = admin,
            ChangedAt = reservation.EndTime.AddHours(2)
        });

        reservation.Payments.Add(new Payment
        {
            StripePaymentIntentId = $"pi_seed_{Guid.NewGuid():N}",
            Amount = reservation.TotalPrice,
            Currency = SeedCurrency,
            Status = PaymentStatus.Succeeded,
            CreatedAt = bookedAt.AddMinutes(5),
            PaidAt = bookedAt.AddMinutes(6)
        });

        dbContext.Add(reservation);
    }

    private static SlotUsage GetOrCreateSeedSlot(
        Dictionary<(int ActivityId, DateTime Day), SlotUsage> slots, Activity activity, DateTime day, Guide guide, DateTime createdAt)
    {
        if (slots.TryGetValue((activity.Id, day), out var existing))
        {
            return existing;
        }

        var start = day.AddHours(SeedSlotStartHour(activity.Name));

        var slot = new ActivitySlot
        {
            StartTime = start,
            EndTime = start.AddMinutes(activity.DurationMinutes),
            Capacity = activity.MaxParticipants,
            Guide = guide,
            CreatedAt = createdAt
        };

        activity.Slots.Add(slot);

        var usage = new SlotUsage(slot);
        slots[(activity.Id, day)] = usage;

        return usage;
    }

    private void AddSeedViews(User guest, ItemType type, int id, int count, DateTime around, Random rng)
    {
        for (var i = 0; i < count; i++)
        {
            var view = new ContentView { User = guest, ViewedAt = around.AddDays(-i).AddHours(-rng.Next(1, 20)) };
            ItemTargets.Assign(view, type, id);
            dbContext.ContentViews.Add(view);
        }
    }

    private static double UseProbability(int affinity) => affinity switch
    {
        >= 5 => 0.8,
        4 => 0.55,
        3 => 0.25,
        _ => 0.08
    };

    private static int SeedRating(Random rng, int affinity)
    {
        var roll = rng.NextDouble();
        var noise = roll < 0.6 ? 0 : roll < 0.8 ? -1 : 1;
        return Math.Clamp(affinity + noise, 1, 5);
    }

    private static string? SeedComment(Random rng, int rating)
    {
        if (rng.NextDouble() < 0.3)
        {
            return null;
        }

        var options = SeedComments[rating];
        return options[rng.Next(options.Length)];
    }

    private static double SeedSlotStartHour(string activityName) => activityName switch
    {
        var name when name.Contains("splav") => 8,
        var name when name.Contains("Pješačka") => 6.5,
        var name when name.Contains("Ribolov") => 4,
        _ => 9
    };

    private static T PickWeighted<T>(Random rng, IReadOnlyList<T> items, Func<T, double> weight)
    {
        var roll = rng.NextDouble() * items.Sum(weight);

        foreach (var item in items)
        {
            roll -= weight(item);

            if (roll <= 0)
            {
                return item;
            }
        }

        return items[^1];
    }

    private static string ToSeedUsername(string firstName, string lastName) =>
        $"{firstName}.{lastName}".ToLowerInvariant()
            .Replace("č", "c").Replace("ć", "c").Replace("š", "s").Replace("ž", "z").Replace("đ", "dj");
}
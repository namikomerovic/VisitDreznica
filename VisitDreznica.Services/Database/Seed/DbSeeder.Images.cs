using System.Reflection;
using System.Text.RegularExpressions;
using Microsoft.EntityFrameworkCore;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Database.Seed;

public partial class DbSeeder
{
    private const string ImageResourcePrefix = "seed-image:";

    private static readonly Assembly SeedAssembly = typeof(DbSeeder).Assembly;

    private static readonly string[] ImageResources = SeedAssembly
        .GetManifestResourceNames()
        .Where(x => x.StartsWith(ImageResourcePrefix, StringComparison.Ordinal))
        .ToArray();

    private async Task SeedImagesAsync()
    {
        if (ImageResources.Length == 0)
        {
            return;
        }

        foreach (var room in await dbContext.Rooms.Where(x => !x.Images.Any()).ToListAsync())
        {
            var files = FindImages("room", room.Name);
            for (var i = 0; i < files.Count; i++)
            {
                room.Images.Add(CreateGalleryImage<RoomImage>(files[i], i));
            }
        }

        foreach (var place in await dbContext.Places.Where(x => !x.Images.Any()).ToListAsync())
        {
            var files = FindImages("place", place.Name);
            for (var i = 0; i < files.Count; i++)
            {
                place.Images.Add(CreateGalleryImage<PlaceImage>(files[i], i));
            }
        }

        foreach (var activity in await dbContext.Activities.Where(x => x.ImageData == null).ToListAsync())
        {
            SetSingleImage(activity, "activity", activity.Name);
        }

        foreach (var equipment in await dbContext.Equipment.Where(x => x.ImageData == null).ToListAsync())
        {
            SetSingleImage(equipment, "equipment", equipment.Name);
        }

        foreach (var news in await dbContext.News.Where(x => x.ImageData == null).ToListAsync())
        {
            SetSingleImage(news, "news", news.Title);
        }

        await dbContext.SaveChangesAsync();
    }

    private static T CreateGalleryImage<T>(SeedImage file, int order) where T : GalleryImage, new() => new()
    {
        Data = file.Data,
        ContentType = file.ContentType,
        IsCover = order == 0,
        DisplayOrder = order,
        CreatedAt = DateTime.UtcNow
    };

    private static void SetSingleImage(IHasImage entity, string prefix, string name)
    {
        var file = FindImages(prefix, name).FirstOrDefault();

        if (file is null)
        {
            return;
        }

        entity.ImageData = file.Data;
        entity.ImageContentType = file.ContentType;
    }

    private static List<SeedImage> FindImages(string prefix, string name)
    {
        var pattern = new Regex($"^{Regex.Escape($"{prefix}-{Slug(name)}")}(?:-(\\d+))?$");

        return ImageResources
            .Select(resource => new
            {
                Resource = resource,
                Match = pattern.Match(Path.GetFileNameWithoutExtension(resource[ImageResourcePrefix.Length..]))
            })
            .Where(x => x.Match.Success)
            .OrderBy(x => x.Match.Groups[1].Success ? int.Parse(x.Match.Groups[1].Value) : 0)
            .Select(x => LoadImage(x.Resource))
            .ToList();
    }

    private static SeedImage LoadImage(string resource)
    {
        using var stream = SeedAssembly.GetManifestResourceStream(resource)
                           ?? throw new InvalidOperationException($"Seed slika '{resource}' nije pronađena.");
        using var memory = new MemoryStream();
        stream.CopyTo(memory);

        var contentType = resource.EndsWith(".png", StringComparison.OrdinalIgnoreCase) ? "image/png" : "image/jpeg";
        return new SeedImage(memory.ToArray(), contentType);
    }

    private static string Slug(string value)
    {
        var lower = value.ToLowerInvariant()
            .Replace("č", "c").Replace("ć", "c").Replace("š", "s").Replace("ž", "z").Replace("đ", "dj");

        return Regex.Replace(lower, "[^a-z0-9]+", "-").Trim('-');
    }

    private sealed record SeedImage(byte[] Data, string ContentType);
}

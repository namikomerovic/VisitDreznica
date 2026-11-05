using VisitDreznica.Model.Exceptions;

namespace VisitDreznica.Services.Images;

public static class ImageValidator
{
    public const int MaxSizeBytes = 5 * 1024 * 1024;

    private static readonly byte[] JpegSignature = [0xFF, 0xD8, 0xFF];
    private static readonly byte[] PngSignature = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A];
    private static readonly string[] AllowedContentTypes = ["image/jpeg", "image/png"];

    public static async Task<FileContentData> ReadAndValidateAsync(Stream content, long length, string declaredContentType)
    {
        if (length == 0)
        {
            throw new BusinessException("Odaberite sliku.");
        }

        if (length > MaxSizeBytes)
        {
            throw new BusinessException("Slika može imati najviše 5 MB.");
        }

        if (!AllowedContentTypes.Contains(declaredContentType))
        {
            throw new BusinessException("Dozvoljene su samo slike u JPG ili PNG formatu.");
        }

        using var memory = new MemoryStream();
        await content.CopyToAsync(memory);
        var data = memory.ToArray();

        var detectedContentType = DetectContentType(data);

        if (detectedContentType is null || detectedContentType != declaredContentType)
        {
            throw new BusinessException("Sadržaj fajla nije ispravna JPG ili PNG slika.");
        }

        return new FileContentData(data, detectedContentType);
    }

    private static string? DetectContentType(byte[] data)
    {
        if (data.AsSpan().StartsWith(JpegSignature))
        {
            return "image/jpeg";
        }

        if (data.AsSpan().StartsWith(PngSignature))
        {
            return "image/png";
        }

        return null;
    }
}

public record FileContentData(byte[] Data, string ContentType);
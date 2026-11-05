namespace VisitDreznica.Services.Database.Entities;

public interface IHasImage : IEntity
{
    byte[]? ImageData { get; set; }
    string? ImageContentType { get; set; }
}
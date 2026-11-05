namespace VisitDreznica.Services.Database.Entities;

public abstract class LookupEntity : IEntity
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
}
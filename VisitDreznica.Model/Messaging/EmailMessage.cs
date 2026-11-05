namespace VisitDreznica.Model.Messaging;

public sealed class EmailMessage
{
    public Guid Id { get; init; } = Guid.NewGuid();
    public required string To { get; init; }
    public string? ToName { get; init; }
    public required string Subject { get; init; }
    public required string HtmlBody { get; init; }
    public DateTime CreatedAt { get; init; } = DateTime.UtcNow;
}
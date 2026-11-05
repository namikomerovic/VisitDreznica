namespace VisitDreznica.Model.Messaging;

public sealed class RabbitMqSettings
{
    public required string Host { get; init; }
    public required int Port { get; init; }
    public required string User { get; init; }
    public required string Password { get; init; }
}
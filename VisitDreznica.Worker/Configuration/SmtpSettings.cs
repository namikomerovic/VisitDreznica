namespace VisitDreznica.Worker.Configuration;

public sealed class SmtpSettings
{
    public required string Host { get; init; }
    public required int Port { get; init; }
    public required string User { get; init; }
    public required string Password { get; init; }
    public required string FromName { get; init; }
}
namespace VisitDreznica.Services.Auth;

public sealed class PasswordResetSettings
{
    public required int CodeExpiryMinutes { get; init; }
}

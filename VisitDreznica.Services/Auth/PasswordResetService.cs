using System.Net;
using System.Security.Cryptography;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using VisitDreznica.Model.Exceptions;
using VisitDreznica.Model.Messaging;
using VisitDreznica.Model.Requests;
using VisitDreznica.Services.Database;
using VisitDreznica.Services.Database.Entities;
using VisitDreznica.Services.Messaging;
using VisitDreznica.Services.Security;

namespace VisitDreznica.Services.Auth;

public class PasswordResetService(
    VisitDreznicaDbContext dbContext,
    IPasswordHasher passwordHasher,
    ISessionService sessionService,
    IEmailQueue emailQueue,
    PasswordResetSettings settings,
    ILogger<PasswordResetService> logger) : IPasswordResetService
{
    private const int MaxFailedAttempts = 5;
    private const string InvalidCodeMessage = "Kod nije ispravan ili je istekao. Provjerite e-mail ili zatražite novi kod.";
    private static readonly TimeSpan ResendDelay = TimeSpan.FromMinutes(1);

    public async Task RequestAsync(PasswordResetRequest request)
    {
        var email = request.Email.Trim();
        var user = await dbContext.Users.FirstOrDefaultAsync(x => x.Email == email && x.IsActive);

        // Odgovor je isti postoji li račun ili ne, da se preko ove forme ne mogu otkrivati registrovani e-mailovi.
        if (user is null)
        {
            logger.LogInformation("Zatražen reset lozinke za e-mail koji ne pripada aktivnom korisniku.");
            return;
        }

        var now = DateTime.UtcNow;
        var openResets = await dbContext.PasswordResets
            .Where(x => x.UserId == user.Id && x.UsedAt == null && x.ExpiresAt > now)
            .ToListAsync();

        if (openResets.Any(x => x.CreatedAt > now - ResendDelay))
        {
            return;
        }

        foreach (var reset in openResets)
        {
            reset.ExpiresAt = now;
        }

        var code = RandomNumberGenerator.GetInt32(0, 1_000_000).ToString("D6");
        var (hash, salt) = passwordHasher.HashPassword(code);

        dbContext.PasswordResets.Add(new PasswordReset
        {
            UserId = user.Id,
            CodeHash = hash,
            CodeSalt = salt,
            CreatedAt = now,
            ExpiresAt = now.AddMinutes(settings.CodeExpiryMinutes)
        });

        await dbContext.SaveChangesAsync();

        await emailQueue.EnqueueAsync(new EmailMessage
        {
            To = user.Email,
            ToName = user.FirstName,
            Subject = "Reset lozinke – Visit Drežnica",
            HtmlBody = BuildHtml(user.FirstName, code, settings.CodeExpiryMinutes)
        });
    }

    public async Task ConfirmAsync(PasswordResetConfirmRequest request)
    {
        var email = request.Email.Trim();
        var now = DateTime.UtcNow;

        var reset = await dbContext.PasswordResets
            .Include(x => x.User)
            .Where(x => x.User.Email == email && x.User.IsActive && x.UsedAt == null && x.ExpiresAt > now)
            .OrderByDescending(x => x.CreatedAt)
            .FirstOrDefaultAsync();

        if (reset is null)
        {
            throw new BusinessException(InvalidCodeMessage);
        }

        if (reset.FailedAttempts >= MaxFailedAttempts)
        {
            throw new BusinessException("Previše pogrešnih pokušaja. Zatražite novi kod.");
        }

        if (!passwordHasher.Verify(request.Code.Trim(), reset.CodeHash, reset.CodeSalt))
        {
            reset.FailedAttempts++;
            await dbContext.SaveChangesAsync();
            throw new BusinessException(InvalidCodeMessage);
        }

        var (hash, salt) = passwordHasher.HashPassword(request.NewPassword);
        reset.User.PasswordHash = hash;
        reset.User.PasswordSalt = salt;
        reset.User.UpdatedAt = now;
        reset.UsedAt = now;

        await sessionService.RevokeAllForUserAsync(reset.UserId);
        await dbContext.SaveChangesAsync();
    }

    private static string BuildHtml(string firstName, string code, int expiryMinutes) =>
        "<div style=\"font-family:Arial,sans-serif;max-width:560px;color:#1f2937\">" +
        "<h2 style=\"color:#0f766e\">Visit Drežnica</h2>" +
        $"<p>Poštovani/a {WebUtility.HtmlEncode(firstName)},</p>" +
        "<p>Zatražili ste reset lozinke. Vaš kod je:</p>" +
        $"<p style=\"font-size:28px;letter-spacing:6px;font-weight:bold\">{code}</p>" +
        $"<p>Kod važi {expiryMinutes} minuta i može se iskoristiti samo jednom.</p>" +
        "<p style=\"color:#6b7280;font-size:13px\">Ako niste vi zatražili reset, zanemarite ovu poruku. Vaša lozinka ostaje ista.</p>" +
        "</div>";
}

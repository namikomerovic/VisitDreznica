using System.Net.Mail;
using MailKit.Net.Smtp;
using MailKit.Security;
using MimeKit;
using VisitDreznica.Model.Messaging;
using VisitDreznica.Worker.Configuration;
using SmtpClient = MailKit.Net.Smtp.SmtpClient;

namespace VisitDreznica.Worker.Email;

public class SmtpEmailSender(SmtpSettings settings) : IEmailSender
{
    private static readonly TimeSpan SendTimeout = TimeSpan.FromSeconds(30);

    public async Task SendAsync(EmailMessage message)
    {
        if (!MailAddress.TryCreate(message.To, out var address) || !address.Host.Contains('.'))
        {
            throw new PermanentEmailException("Neispravna email adresa primaoca.");
        }

        var mime = new MimeMessage();
        mime.From.Add(new MailboxAddress(settings.FromName, settings.User));
        mime.To.Add(new MailboxAddress(message.ToName, address.Address));
        mime.Subject = message.Subject;
        mime.Body = new BodyBuilder { HtmlBody = message.HtmlBody }.ToMessageBody();

        using var timeout = new CancellationTokenSource(SendTimeout);
        using var client = new SmtpClient();

        try
        {
            await client.ConnectAsync(settings.Host, settings.Port, SecureSocketOptions.StartTls, timeout.Token);
            await client.AuthenticateAsync(settings.User, settings.Password, timeout.Token);
            await client.SendAsync(mime, timeout.Token);
            await client.DisconnectAsync(true, timeout.Token);
        }
        catch (SmtpCommandException ex) when (ex.ErrorCode == SmtpErrorCode.RecipientNotAccepted)
        {
            throw new PermanentEmailException("Mail server je odbio adresu primaoca.");
        }
    }
}
using VisitDreznica.Model.Messaging;

namespace VisitDreznica.Worker.Email;

public interface IEmailSender
{
    Task SendAsync(EmailMessage message);
}
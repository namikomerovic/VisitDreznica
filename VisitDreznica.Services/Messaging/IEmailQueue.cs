using VisitDreznica.Model.Messaging;

namespace VisitDreznica.Services.Messaging;

public interface IEmailQueue
{
    Task EnqueueAsync(EmailMessage message);
}
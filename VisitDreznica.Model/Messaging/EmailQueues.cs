namespace VisitDreznica.Model.Messaging;

public static class EmailQueues
{
    public const string Send = "email.send";
    public const string Dead = "email.send.dead";

    public static string Retry(int attempt) => $"email.send.retry.{attempt}";
}
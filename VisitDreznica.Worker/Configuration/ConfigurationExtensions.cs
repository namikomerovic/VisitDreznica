using VisitDreznica.Model.Messaging;

namespace VisitDreznica.Worker.Configuration;

internal static class ConfigurationExtensions
{
    public static string GetRequired(this IConfiguration configuration, string key) =>
        configuration[key] is { Length: > 0 } value
            ? value
            : throw new InvalidOperationException($"Varijabla okruženja {key} nije postavljena.");

    public static int GetRequiredInt(this IConfiguration configuration, string key) =>
        int.TryParse(configuration.GetRequired(key), out var value)
            ? value
            : throw new InvalidOperationException($"Varijabla okruženja {key} mora biti cijeli broj.");

    public static RabbitMqSettings GetRabbitMqSettings(this IConfiguration configuration) =>
        new()
        {
            Host = configuration.GetRequired("RABBITMQ_HOST"),
            Port = configuration.GetRequiredInt("RABBITMQ_PORT"),
            User = configuration.GetRequired("RABBITMQ_USER"),
            Password = configuration.GetRequired("RABBITMQ_PASSWORD")
        };

    public static SmtpSettings GetSmtpSettings(this IConfiguration configuration) =>
        new()
        {
            Host = configuration.GetRequired("SMTP_HOST"),
            Port = configuration.GetRequiredInt("SMTP_PORT"),
            User = configuration.GetRequired("SMTP_USER"),
            Password = configuration.GetRequired("SMTP_PASSWORD"),
            FromName = configuration.GetRequired("SMTP_FROM_NAME")
        };
}
using Microsoft.Data.SqlClient;
using System.Text;
using VisitDreznica.Services.Security;
using System.Globalization;
using VisitDreznica.Services.Reservations;
using VisitDreznica.Services.Payments;

namespace VisitDreznica.API.Configuration;

public static class ConfigurationExtensions
{
    public static string GetRequired(this IConfiguration configuration, string key) =>
        configuration[key] is { Length: > 0 } value
            ? value
            : throw new InvalidOperationException($"Konfiguracijska vrijednost '{key}' nije postavljena (.env).");

    public static string GetSqlConnectionString(this IConfiguration configuration)
    {
        var connection = new SqlConnectionStringBuilder
        {
            DataSource = $"{configuration.GetRequired("DB_HOST")},{configuration.GetRequired("DB_PORT")}",
            InitialCatalog = configuration.GetRequired("DB_NAME"),
            UserID = configuration.GetRequired("DB_USER"),
            Password = configuration.GetRequired("DB_PASSWORD"),
            TrustServerCertificate = true
        };

        return connection.ConnectionString;
    }

    public static JwtSettings GetJwtSettings(this IConfiguration configuration)
    {
        var secret = configuration.GetRequired("JWT_SECRET");

        if (Encoding.UTF8.GetByteCount(secret) < 32)
        {
            throw new InvalidOperationException("JWT_SECRET mora imati najmanje 32 znaka.");
        }

        return new JwtSettings
        {
            Secret = secret,
            Issuer = configuration.GetRequired("JWT_ISSUER"),
            Audience = configuration.GetRequired("JWT_AUDIENCE"),
            ExpiryMinutes = int.Parse(configuration.GetRequired("JWT_EXPIRY_MINUTES"))
        };
    }

    public static ReservationSettings GetReservationSettings(this IConfiguration configuration) =>
    new()
    {
        TouristTaxPerPersonNight = decimal.Parse(configuration.GetRequired("TOURIST_TAX_PER_PERSON_NIGHT"), CultureInfo.InvariantCulture)
    };

    public static PaymentSettings GetPaymentSettings(this IConfiguration configuration) =>
    new()
    {
        SecretKey = configuration.GetRequired("STRIPE_SECRET_KEY"),
        PublishableKey = configuration.GetRequired("STRIPE_PUBLISHABLE_KEY"),
        Currency = configuration.GetRequired("STRIPE_CURRENCY").ToLowerInvariant()
    };
}
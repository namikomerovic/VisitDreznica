using Microsoft.Data.SqlClient;

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
}
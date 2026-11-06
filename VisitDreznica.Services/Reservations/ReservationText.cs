using System.Globalization;
using VisitDreznica.Model.Enums;

namespace VisitDreznica.Services.Reservations;

public static class ReservationText
{
    private static readonly TimeZoneInfo LocalZone = TimeZoneInfo.FindSystemTimeZoneById("Europe/Sarajevo");

    public static string TypeLabel(ReservationType type) => type switch
    {
        ReservationType.Room => "Smještaj",
        ReservationType.Equipment => "Najam opreme",
        _ => "Aktivnost"
    };

    public static string FormatLocal(DateTime utc) =>
        TimeZoneInfo.ConvertTimeFromUtc(utc, LocalZone).ToString("dd.MM.yyyy. HH:mm", CultureInfo.InvariantCulture);

    public static string FormatMoney(decimal amount, string currency)
    {
        var label = currency == "bam" ? "KM" : currency.ToUpperInvariant();
        return $"{amount.ToString("0.00", CultureInfo.InvariantCulture).Replace('.', ',')} {label}";
    }
}
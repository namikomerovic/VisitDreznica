using System.Net;
using System.Text;
using Microsoft.EntityFrameworkCore;
using VisitDreznica.Model.Enums;
using VisitDreznica.Model.Messaging;
using VisitDreznica.Services.Database;
using VisitDreznica.Services.Database.Entities;
using VisitDreznica.Services.Payments;
using VisitDreznica.Services.Reservations;

namespace VisitDreznica.Services.Messaging;

public class ReservationEmailService(
    VisitDreznicaDbContext dbContext,
    IEmailQueue emailQueue,
    PaymentSettings paymentSettings) : IReservationEmailService
{
    private const string RefundNote = "Sredstva su obično vidljiva na vašem računu za 5 do 10 radnih dana.";

    public async Task NotifyStatusChangedAsync(int reservationId)
    {
        var data = await dbContext.Reservations
            .AsNoTracking()
            .Where(x => x.Id == reservationId)
            .Select(x => new
            {
                x.Id,
                x.Status,
                x.StartTime,
                x.EndTime,
                x.TotalPrice,
                x.User.Email,
                x.User.FirstName,
                Type = x is RoomReservation
                    ? ReservationType.Room
                    : x is EquipmentReservation
                        ? ReservationType.Equipment
                        : ReservationType.Activity,
                LastComment = x.StatusHistory
                    .OrderByDescending(h => h.ChangedAt)
                    .Select(h => h.Comment)
                    .FirstOrDefault(),
                RefundedAmount = x.Payments.SelectMany(p => p.Refunds).Sum(r => (decimal?)r.Amount) ?? 0
            })
            .FirstOrDefaultAsync();

        if (data is null || string.IsNullOrWhiteSpace(data.Email))
        {
            return;
        }

        var (subject, intro) = data.Status switch
        {
            ReservationStatus.Confirmed => ($"Rezervacija #{data.Id} je potvrđena",
                "Vaša rezervacija je potvrđena. Radujemo se vašem dolasku u Drežnicu!"),
            ReservationStatus.Rejected => ($"Rezervacija #{data.Id} je odbijena",
                "Nažalost, vašu rezervaciju nismo mogli prihvatiti."),
            ReservationStatus.Cancelled => ($"Rezervacija #{data.Id} je otkazana",
                "Vaša rezervacija je otkazana."),
            _ => (null, null)
        };

        if (subject is null || intro is null)
        {
            return;
        }

        var rows = new List<(string Label, string Value)>
        {
            ("Vrsta", ReservationText.TypeLabel(data.Type)),
            ("Početak", ReservationText.FormatLocal(data.StartTime)),
            ("Kraj", ReservationText.FormatLocal(data.EndTime)),
            ("Iznos", ReservationText.FormatMoney(data.TotalPrice, paymentSettings.Currency))
        };

        if (data.Status != ReservationStatus.Confirmed && !string.IsNullOrWhiteSpace(data.LastComment))
        {
            rows.Add(("Razlog", data.LastComment));
        }

        string? note = data.RefundedAmount > 0
            ? $"Uplaćeni iznos od {ReservationText.FormatMoney(data.RefundedAmount, paymentSettings.Currency)} vraćen je na vašu karticu. {RefundNote}"
            : null;

        await emailQueue.EnqueueAsync(new EmailMessage
        {
            To = data.Email,
            ToName = data.FirstName,
            Subject = subject,
            HtmlBody = BuildHtml(data.FirstName, intro, rows, note)
        });
    }

    private static string BuildHtml(string firstName, string intro, List<(string Label, string Value)> rows, string? note)
    {
        var html = new StringBuilder();
        html.Append("<div style=\"font-family:Arial,sans-serif;max-width:560px;color:#1f2937\">");
        html.Append("<h2 style=\"color:#0f766e\">Visit Drežnica</h2>");
        html.Append($"<p>Poštovani/a {Encode(firstName)},</p>");
        html.Append($"<p>{Encode(intro)}</p>");
        html.Append("<table style=\"border-collapse:collapse;margin:16px 0\">");

        foreach (var (label, value) in rows)
        {
            html.Append($"<tr><td style=\"padding:4px 16px 4px 0;color:#6b7280\">{Encode(label)}</td>");
            html.Append($"<td style=\"padding:4px 0\"><strong>{Encode(value)}</strong></td></tr>");
        }

        html.Append("</table>");

        if (note is not null)
        {
            html.Append($"<p style=\"background:#ecfdf5;padding:12px;border-radius:6px\">{Encode(note)}</p>");
        }

        html.Append("<p style=\"color:#6b7280;font-size:13px\">Ovo je automatska poruka, molimo ne odgovarajte na nju.</p>");
        html.Append("</div>");

        return html.ToString();
    }

    private static string Encode(string value) => WebUtility.HtmlEncode(value);
}
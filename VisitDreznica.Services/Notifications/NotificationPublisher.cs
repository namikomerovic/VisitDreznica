using Microsoft.EntityFrameworkCore;
using VisitDreznica.Model.Constants;
using VisitDreznica.Model.Enums;
using VisitDreznica.Services.Database;
using VisitDreznica.Services.Database.Entities;
using VisitDreznica.Services.Payments;
using VisitDreznica.Services.Reservations;

namespace VisitDreznica.Services.Notifications;

public class NotificationPublisher(VisitDreznicaDbContext dbContext, PaymentSettings paymentSettings) : INotificationPublisher
{
    private const int MaxMessageLength = 1000;

    public async Task ReservationStatusChangedAsync(int reservationId)
    {
        var data = await dbContext.Reservations
            .AsNoTracking()
            .Where(x => x.Id == reservationId)
            .Select(x => new
            {
                x.Id,
                x.UserId,
                x.Status,
                x.StartTime,
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

        if (data is null)
        {
            return;
        }

        var what = $"{ReservationText.TypeLabel(data.Type)}, {ReservationText.FormatLocal(data.StartTime)}.";
        var reason = string.IsNullOrWhiteSpace(data.LastComment) ? string.Empty : $" Razlog: {data.LastComment}";
        var refund = data.RefundedAmount > 0
            ? $" Iznos od {ReservationText.FormatMoney(data.RefundedAmount, paymentSettings.Currency)} vraćen je na vašu karticu."
            : string.Empty;

        var (title, message) = data.Status switch
        {
            ReservationStatus.Confirmed => ($"Rezervacija #{data.Id} je potvrđena",
                $"{what} Radujemo se vašem dolasku!"),
            ReservationStatus.Rejected => ($"Rezervacija #{data.Id} je odbijena",
                $"{what}{reason}{refund}"),
            ReservationStatus.Cancelled => ($"Rezervacija #{data.Id} je otkazana",
                $"{what}{reason}{refund}"),
            ReservationStatus.Completed => ("Kako vam je bilo?",
                $"Rezervacija #{data.Id} je završena. Ocijenite iskustvo i pomozite drugim gostima pri izboru."),
            _ => (null, null)
        };

        if (title is null || message is null)
        {
            return;
        }

        dbContext.Notifications.Add(Create(data.UserId, title, message, NotificationType.Reservation, data.Id));
        await dbContext.SaveChangesAsync();
    }

    public async Task ReservationPaidAsync(int reservationId)
    {
        var data = await dbContext.Reservations
            .AsNoTracking()
            .Where(x => x.Id == reservationId)
            .Select(x => new
            {
                x.Id,
                x.StartTime,
                x.TotalPrice,
                GuestName = x.User.FirstName + " " + x.User.LastName,
                Type = x is RoomReservation
                    ? ReservationType.Room
                    : x is EquipmentReservation
                        ? ReservationType.Equipment
                        : ReservationType.Activity
            })
            .FirstOrDefaultAsync();

        if (data is null)
        {
            return;
        }

        var adminIds = await dbContext.Users
            .Where(x => x.IsActive && x.UserRoles.Any(r => r.Role.Name == AppRoles.Admin))
            .Select(x => x.Id)
            .ToListAsync();

        var title = $"Nova plaćena rezervacija #{data.Id}";
        var message = $"{data.GuestName} je platio/la: {ReservationText.TypeLabel(data.Type)}, " +
                      $"{ReservationText.FormatLocal(data.StartTime)} " +
                      $"({ReservationText.FormatMoney(data.TotalPrice, paymentSettings.Currency)}). Rezervacija čeka potvrdu.";

        foreach (var adminId in adminIds)
        {
            dbContext.Notifications.Add(Create(adminId, title, message, NotificationType.Payment, data.Id));
        }

        await dbContext.SaveChangesAsync();
    }

    private static Notification Create(int userId, string title, string message, NotificationType type, int? reservationId) => new()
    {
        UserId = userId,
        Title = title,
        Message = message.Length > MaxMessageLength ? message[..MaxMessageLength] : message,
        Type = type,
        ReservationId = reservationId,
        CreatedAt = DateTime.UtcNow
    };
}
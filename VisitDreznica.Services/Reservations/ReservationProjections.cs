using System.Linq.Expressions;
using VisitDreznica.Model.Enums;
using VisitDreznica.Model.Responses;
using VisitDreznica.Services.Database.Entities;
using Microsoft.EntityFrameworkCore;
using VisitDreznica.Services.Database;

namespace VisitDreznica.Services.Reservations;

public static class ReservationProjections
{
    public static readonly Expression<Func<Reservation, ReservationResponse>> ToResponse = r => new ReservationResponse
    {
        Id = r.Id,
        Type = r is RoomReservation ? ReservationType.Room
            : r is EquipmentReservation ? ReservationType.Equipment
            : ReservationType.Activity,
        Status = r.Status,
        StartTime = r.StartTime,
        EndTime = r.EndTime,
        TotalPrice = r.TotalPrice,
        IsPaid = r.Payments.Any(p => p.Status == PaymentStatus.Succeeded),
        Note = r.Note,
        CreatedAt = r.CreatedAt,
        UserId = r.UserId,
        UserFullName = r.User.FirstName + " " + r.User.LastName,

        ItemName = r is RoomReservation ? ((RoomReservation)r).Room.Name
            : r is EquipmentReservation ? ((EquipmentReservation)r).Equipment.Name
            : ((ActivityReservation)r).ActivitySlot.Activity.Name,

        RoomId = r is RoomReservation ? (int?)((RoomReservation)r).RoomId : null,
        GuestCount = r is RoomReservation ? (int?)((RoomReservation)r).GuestCount : null,

        EquipmentId = r is EquipmentReservation ? (int?)((EquipmentReservation)r).EquipmentId : null,
        Quantity = r is EquipmentReservation ? (int?)((EquipmentReservation)r).Quantity : null,

        ActivityId = r is ActivityReservation ? (int?)((ActivityReservation)r).ActivitySlot.ActivityId : null,
        ActivitySlotId = r is ActivityReservation ? (int?)((ActivityReservation)r).ActivitySlotId : null,
        ParticipantCount = r is ActivityReservation ? (int?)((ActivityReservation)r).ParticipantCount : null
    };

    public static Task<ReservationResponse> GetResponseAsync(this VisitDreznicaDbContext dbContext, int reservationId) =>
    dbContext.Reservations
        .AsNoTracking()
        .Where(x => x.Id == reservationId)
        .Select(ToResponse)
        .FirstAsync();
}
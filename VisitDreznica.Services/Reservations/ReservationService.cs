using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using VisitDreznica.Model.Constants;
using VisitDreznica.Model.Enums;
using VisitDreznica.Model.Exceptions;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Base;
using VisitDreznica.Services.Database;
using VisitDreznica.Services.Database.Entities;
using VisitDreznica.Services.Messaging;
using VisitDreznica.Services.Payments;
using VisitDreznica.Services.Reservations.StateMachine;
using VisitDreznica.Services.Security;

namespace VisitDreznica.Services.Reservations;

public class ReservationService(
    VisitDreznicaDbContext dbContext,
    IMapper mapper,
    ICurrentUser currentUser,
    IReservationPaymentService reservationPaymentService,
    IReservationEmailService reservationEmailService)
    : BaseReadService<Reservation, ReservationResponse, ReservationSearchObject>(dbContext, mapper),
      IReservationService
{
    protected override string EntityDisplayName => "rezervacija";

    protected override IQueryable<ReservationResponse> Project(IQueryable<Reservation> query) =>
        query.Select(ReservationProjections.ToResponse);

    protected override IQueryable<Reservation> ApplyFilters(IQueryable<Reservation> query, ReservationSearchObject search)
    {
        if (!currentUser.IsInRole(AppRoles.Admin))
        {
            var userId = currentUser.UserId;
            query = query.Where(x => x.UserId == userId);
        }
        else
        {
            if (search.UserId.HasValue)
            {
                query = query.Where(x => x.UserId == search.UserId.Value);
            }

            if (!string.IsNullOrWhiteSpace(search.GuestName))
            {
                query = query.Where(x => (x.User.FirstName + " " + x.User.LastName).Contains(search.GuestName));
            }
        }

        query = search.Type switch
        {
            ReservationType.Room => query.Where(x => x is RoomReservation),
            ReservationType.Equipment => query.Where(x => x is EquipmentReservation),
            ReservationType.Activity => query.Where(x => x is ActivityReservation),
            _ => query
        };

        if (search.Statuses is { Count: > 0 })
        {
            query = query.Where(x => search.Statuses.Contains(x.Status));
        }

        if (search.From.HasValue)
        {
            var from = search.From.Value.ToUniversalTime();
            query = query.Where(x => x.EndTime >= from);
        }

        if (search.To.HasValue)
        {
            var to = search.To.Value.ToUniversalTime();
            query = query.Where(x => x.StartTime <= to);
        }

        return query;
    }

    protected override IQueryable<Reservation> ApplyOrdering(IQueryable<Reservation> query, ReservationSearchObject search) =>
        search.OrderByStartTime
            ? query.OrderBy(x => x.StartTime)
            : query.OrderByDescending(x => x.CreatedAt);

    public override async Task<ReservationResponse> GetByIdAsync(int id)
    {
        var query = DbContext.Reservations.AsNoTracking().Where(x => x.Id == id);

        if (!currentUser.IsInRole(AppRoles.Admin))
        {
            var userId = currentUser.UserId;
            query = query.Where(x => x.UserId == userId);
        }

        var reservation = await query.Select(ReservationProjections.ToResponse).FirstOrDefaultAsync()
                          ?? throw new NotFoundException("Tražena rezervacija ne postoji.");

        reservation.StatusHistory = await DbContext.ReservationStatusHistory
            .AsNoTracking()
            .Where(x => x.ReservationId == id)
            .OrderBy(x => x.ChangedAt)
            .Select(x => new ReservationStatusHistoryResponse
            {
                FromStatus = x.FromStatus,
                ToStatus = x.ToStatus,
                ChangedAt = x.ChangedAt,
                ChangedByFullName = x.ChangedByUser != null
                    ? x.ChangedByUser.FirstName + " " + x.ChangedByUser.LastName
                    : "Sistem",
                Comment = x.Comment
            })
            .ToListAsync();

        return reservation;
    }

    public Task<ReservationResponse> ConfirmAsync(int id, ReservationStatusChangeRequest request) =>
        ChangeStatusAsync(id, request.Comment, (state, reservation, context) => state.Confirm(reservation, context));

    public Task<ReservationResponse> RejectAsync(int id, ReservationStatusChangeRequest request) =>
        ChangeStatusAsync(id, request.Comment, (state, reservation, context) => state.Reject(reservation, context));

    public Task<ReservationResponse> CancelAsync(int id, ReservationStatusChangeRequest request) =>
        ChangeStatusAsync(id, request.Comment, (state, reservation, context) => state.Cancel(reservation, context));

    public Task<ReservationResponse> CompleteAsync(int id, ReservationStatusChangeRequest request) =>
        ChangeStatusAsync(id, request.Comment, (state, reservation, context) => state.Complete(reservation, context));

    private async Task<ReservationResponse> ChangeStatusAsync(
        int id,
        string? comment,
        Action<ReservationState, Reservation, TransitionContext> transition)
    {
        var reservation = await DbContext.Reservations.FirstOrDefaultAsync(x => x.Id == id)
                          ?? throw new NotFoundException("Tražena rezervacija ne postoji.");

        var isAdmin = currentUser.IsInRole(AppRoles.Admin);

        if (!isAdmin && reservation.UserId != currentUser.UserId)
        {
            throw new NotFoundException("Tražena rezervacija ne postoji.");
        }

        var now = DateTime.UtcNow;
        var trimmedComment = string.IsNullOrWhiteSpace(comment) ? null : comment.Trim();
        var fromStatus = reservation.Status;

        var isPaid = await DbContext.Payments.AnyAsync(x => x.ReservationId == id && x.Status == PaymentStatus.Succeeded);

        var state = ReservationStateMachine.For(fromStatus);
        transition(state, reservation, new TransitionContext(isAdmin, trimmedComment, now, isPaid));

        reservation.UpdatedAt = now;
        ReservationHistory.Record(reservation, fromStatus, reservation.Status, currentUser.UserId, trimmedComment, now);

        if (reservation.Status is ReservationStatus.Cancelled or ReservationStatus.Rejected)
        {
            var reason = trimmedComment ?? (reservation.Status == ReservationStatus.Rejected
                ? "Rezervacija je odbijena."
                : "Rezervacija je otkazana.");

            await reservationPaymentService.ReverseAsync(reservation.Id, reason);
        }

        await DbContext.SaveChangesAsync();

        await reservationEmailService.NotifyStatusChangedAsync(reservation.Id);

        return await GetByIdAsync(id);
    }
}
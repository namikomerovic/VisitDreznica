using VisitDreznica.Model.Enums;
using VisitDreznica.Model.Exceptions;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Reservations.StateMachine;

public abstract class ReservationState
{
    public static readonly TimeSpan GuestCancellationDeadline = TimeSpan.FromHours(24);

    public abstract ReservationStatus Status { get; }
    public abstract string DisplayName { get; }

    public virtual void Confirm(Reservation reservation, TransitionContext context) => throw NotAllowed("potvrditi");
    public virtual void Reject(Reservation reservation, TransitionContext context) => throw NotAllowed("odbiti");
    public virtual void Cancel(Reservation reservation, TransitionContext context) => throw NotAllowed("otkazati");
    public virtual void Complete(Reservation reservation, TransitionContext context) => throw NotAllowed("označiti kao završenu");

    protected BusinessException NotAllowed(string action) =>
        new($"Rezervaciju sa statusom '{DisplayName}' nije moguće {action}.");

    protected static void RequireAdmin(TransitionContext context)
    {
        if (!context.IsAdmin)
        {
            throw new BusinessException("Ovu akciju može izvršiti samo administrator.");
        }
    }

    protected static void RequireReason(TransitionContext context, string message)
    {
        if (string.IsNullOrWhiteSpace(context.Reason))
        {
            throw new BusinessException(message);
        }
    }
}
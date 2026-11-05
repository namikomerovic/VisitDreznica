using VisitDreznica.Model.Enums;
using VisitDreznica.Model.Exceptions;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Reservations.StateMachine;

public sealed class PendingState : ReservationState
{
    public override ReservationStatus Status => ReservationStatus.Pending;
    public override string DisplayName => "Na čekanju";

public override void Confirm(Reservation reservation, TransitionContext context)
{
    RequireAdmin(context);

    if (!context.IsPaid)
    {
        throw new BusinessException("Rezervacija još nije plaćena i ne može se potvrditi.");
    }

    reservation.Status = ReservationStatus.Confirmed;
}

    public override void Reject(Reservation reservation, TransitionContext context)
    {
        RequireAdmin(context);
        RequireReason(context, "Razlog odbijanja je obavezan.");
        reservation.Status = ReservationStatus.Rejected;
    }

    public override void Cancel(Reservation reservation, TransitionContext context)
    {
        if (context.IsAdmin)
        {
            RequireReason(context, "Razlog otkazivanja je obavezan.");
        }

        reservation.Status = ReservationStatus.Cancelled;
    }
}

public sealed class ConfirmedState : ReservationState
{
    public override ReservationStatus Status => ReservationStatus.Confirmed;
    public override string DisplayName => "Potvrđena";

    public override void Cancel(Reservation reservation, TransitionContext context)
    {
        if (context.IsAdmin)
        {
            RequireReason(context, "Razlog otkazivanja je obavezan.");
        }
        else if (reservation.StartTime - context.Now < GuestCancellationDeadline)
        {
            throw new BusinessException("Potvrđenu rezervaciju je moguće otkazati najkasnije 24 sata prije početka.");
        }

        reservation.Status = ReservationStatus.Cancelled;
    }

    public override void Complete(Reservation reservation, TransitionContext context)
    {
        RequireAdmin(context);

        if (reservation.EndTime > context.Now)
        {
            throw new BusinessException("Rezervacija se može označiti kao završena tek nakon što usluga završi.");
        }

        reservation.Status = ReservationStatus.Completed;
    }
}

public sealed class CompletedState : ReservationState
{
    public override ReservationStatus Status => ReservationStatus.Completed;
    public override string DisplayName => "Završena";
}

public sealed class CancelledState : ReservationState
{
    public override ReservationStatus Status => ReservationStatus.Cancelled;
    public override string DisplayName => "Otkazana";
}

public sealed class RejectedState : ReservationState
{
    public override ReservationStatus Status => ReservationStatus.Rejected;
    public override string DisplayName => "Odbijena";
}
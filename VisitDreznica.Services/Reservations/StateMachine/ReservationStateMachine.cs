using VisitDreznica.Model.Enums;

namespace VisitDreznica.Services.Reservations.StateMachine;

public static class ReservationStateMachine
{
    private static readonly Dictionary<ReservationStatus, ReservationState> States =
        new ReservationState[]
        {
            new PendingState(),
            new ConfirmedState(),
            new CompletedState(),
            new CancelledState(),
            new RejectedState()
        }.ToDictionary(state => state.Status);

    public static ReservationState For(ReservationStatus status) => States[status];

    public static string DisplayName(ReservationStatus status) => For(status).DisplayName;
}
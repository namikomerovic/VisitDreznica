namespace VisitDreznica.Services.Reservations.StateMachine;

public sealed record TransitionContext(bool IsAdmin, string? Reason, DateTime Now);
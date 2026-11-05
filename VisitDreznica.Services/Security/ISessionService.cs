namespace VisitDreznica.Services.Security;

public interface ISessionService
{
    Task<bool> IsActiveAsync(Guid sessionId);
    Task RevokeAsync(Guid sessionId);

    Task RevokeAllForUserAsync(int userId, Guid? exceptSessionId = null);
}
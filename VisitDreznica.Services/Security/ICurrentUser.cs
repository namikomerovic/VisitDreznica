namespace VisitDreznica.Services.Security;

public interface ICurrentUser
{
    int UserId { get; }
    Guid SessionId { get; }
    bool IsInRole(string role);
}
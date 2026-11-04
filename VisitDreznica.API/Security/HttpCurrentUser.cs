using System.Security.Claims;
using VisitDreznica.Model.Constants;
using VisitDreznica.Services.Security;

namespace VisitDreznica.API.Security;

public class HttpCurrentUser(IHttpContextAccessor httpContextAccessor) : ICurrentUser
{
    private ClaimsPrincipal Principal =>
        httpContextAccessor.HttpContext?.User
        ?? throw new UnauthorizedAccessException("Korisnik nije prijavljen.");

    public int UserId =>
        int.TryParse(Principal.FindFirstValue(ClaimTypes.NameIdentifier), out var userId)
            ? userId
            : throw new UnauthorizedAccessException("Korisnik nije prijavljen.");

    public Guid SessionId =>
        Guid.TryParse(Principal.FindFirstValue(AppClaims.SessionId), out var sessionId)
            ? sessionId
            : throw new UnauthorizedAccessException("Korisnik nije prijavljen.");

    public bool IsInRole(string role) => Principal.IsInRole(role);
}
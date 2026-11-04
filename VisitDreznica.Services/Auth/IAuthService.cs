using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;

namespace VisitDreznica.Services.Auth;

public interface IAuthService
{
    Task<LoginResponse> LoginAsync(LoginRequest request);
    Task<LoginResponse> RegisterAsync(RegisterRequest request);
    Task LogoutAsync();
}
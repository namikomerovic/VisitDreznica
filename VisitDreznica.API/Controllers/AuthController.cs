using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Services.Auth;
using VisitDreznica.Services.Locations;
using VisitDreznica.Model.SearchObjects;

namespace VisitDreznica.API.Controllers;

[ApiController]
[Route("[controller]")]
[Authorize]
public class AuthController(IAuthService authService, IPasswordResetService passwordResetService, ICityService cityService)
    : ControllerBase
{
    [AllowAnonymous]
    [HttpPost("login")]
    public Task<LoginResponse> Login([FromBody] LoginRequest request) => authService.LoginAsync(request);

    [AllowAnonymous]
    [HttpPost("register")]
    public Task<LoginResponse> Register([FromBody] RegisterRequest request) => authService.RegisterAsync(request);

    [AllowAnonymous]
    [HttpPost("password-reset/request")]
    public async Task<IActionResult> RequestPasswordReset([FromBody] PasswordResetRequest request)
    {
        await passwordResetService.RequestAsync(request);
        return NoContent();
    }

    [AllowAnonymous]
    [HttpPost("password-reset/confirm")]
    public async Task<IActionResult> ConfirmPasswordReset([FromBody] PasswordResetConfirmRequest request)
    {
        await passwordResetService.ConfirmAsync(request);
        return NoContent();
    }

    [HttpPost("logout")]
    public async Task<IActionResult> Logout()
    {
        await authService.LogoutAsync();
        return NoContent();
    }

    [AllowAnonymous]
    [HttpGet("cities")]
    public Task<PageResult<CityResponse>> GetCitiesForRegistration([FromQuery] CitySearchObject search) =>
        cityService.GetPagedAsync(search);
}
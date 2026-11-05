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
public class AuthController(IAuthService authService, ICityService cityService) : ControllerBase
{
    [AllowAnonymous]
    [HttpPost("login")]
    public Task<LoginResponse> Login([FromBody] LoginRequest request) => authService.LoginAsync(request);

    [AllowAnonymous]
    [HttpPost("register")]
    public Task<LoginResponse> Register([FromBody] RegisterRequest request) => authService.RegisterAsync(request);

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
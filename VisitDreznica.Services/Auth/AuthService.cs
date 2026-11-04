using System.Security.Claims;
using System.Text;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.JsonWebTokens;
using Microsoft.IdentityModel.Tokens;
using VisitDreznica.Model.Constants;
using VisitDreznica.Model.Exceptions;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Services.Database;
using VisitDreznica.Services.Database.Entities;
using VisitDreznica.Services.Security;

namespace VisitDreznica.Services.Auth;

public class AuthService(
    VisitDreznicaDbContext dbContext,
    IPasswordHasher passwordHasher,
    ISessionService sessionService,
    ICurrentUser currentUser,
    JwtSettings jwtSettings) : IAuthService
{
    public async Task<LoginResponse> LoginAsync(LoginRequest request)
    {
        var username = request.Username.Trim();

        var user = await dbContext.Users
            .Include(x => x.UserRoles).ThenInclude(x => x.Role)
            .FirstOrDefaultAsync(x => x.Username == username);

        if (user is null || !passwordHasher.Verify(request.Password, user.PasswordHash, user.PasswordSalt))
        {
            throw new BusinessException("Pogrešno korisničko ime ili lozinka.");
        }

        if (!user.IsActive)
        {
            throw new BusinessException("Korisnički račun je deaktiviran. Obratite se administratoru.");
        }

        return await CreateSessionAsync(user);
    }

    public async Task<LoginResponse> RegisterAsync(RegisterRequest request)
    {
        var username = request.Username.Trim();
        var email = request.Email.Trim();

        if (await dbContext.Users.AnyAsync(x => x.Username == username))
        {
            throw new BusinessException($"Korisničko ime '{username}' je zauzeto.");
        }

        if (await dbContext.Users.AnyAsync(x => x.Email == email))
        {
            throw new BusinessException("Korisnik s ovom e-mail adresom već postoji.");
        }

        if (!await dbContext.Cities.AnyAsync(x => x.Id == request.CityId))
        {
            throw new BusinessException("Odabrani grad ne postoji.");
        }

        var guestRole = await dbContext.Roles.FirstAsync(x => x.Name == AppRoles.Guest);
        var (hash, salt) = passwordHasher.HashPassword(request.Password);

        var user = new User
        {
            FirstName = request.FirstName.Trim(),
            LastName = request.LastName.Trim(),
            Email = email,
            Username = username,
            PhoneNumber = request.PhoneNumber?.Trim(),
            CityId = request.CityId,
            PasswordHash = hash,
            PasswordSalt = salt,
            IsActive = true,
            CreatedAt = DateTime.UtcNow
        };
        user.UserRoles.Add(new UserRole { Role = guestRole });

        dbContext.Users.Add(user);

        return await CreateSessionAsync(user);
    }

    public Task LogoutAsync() => sessionService.RevokeAsync(currentUser.SessionId);

    private async Task<LoginResponse> CreateSessionAsync(User user)
    {
        var now = DateTime.UtcNow;
        var session = new UserSession
        {
            Id = Guid.NewGuid(),
            User = user,
            CreatedAt = now,
            ExpiresAt = now.AddMinutes(jwtSettings.ExpiryMinutes)
        };

        dbContext.UserSessions.Add(session);
        await dbContext.SaveChangesAsync();

        var roles = user.UserRoles.Select(x => x.Role.Name).ToList();

        return new LoginResponse
        {
            Token = CreateToken(user, session, roles),
            ExpiresAt = session.ExpiresAt,
            UserId = user.Id,
            Username = user.Username,
            FullName = $"{user.FirstName} {user.LastName}",
            Roles = roles
        };
    }

    private string CreateToken(User user, UserSession session, List<string> roles)
    {
        var claims = new List<Claim>
        {
            new(ClaimTypes.NameIdentifier, user.Id.ToString()),
            new(ClaimTypes.Name, user.Username),
            new(AppClaims.SessionId, session.Id.ToString())
        };
        claims.AddRange(roles.Select(role => new Claim(ClaimTypes.Role, role)));

        var signingKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSettings.Secret));

        var descriptor = new SecurityTokenDescriptor
        {
            Subject = new ClaimsIdentity(claims),
            Issuer = jwtSettings.Issuer,
            Audience = jwtSettings.Audience,
            Expires = session.ExpiresAt,
            SigningCredentials = new SigningCredentials(signingKey, SecurityAlgorithms.HmacSha256)
        };

        return new JsonWebTokenHandler().CreateToken(descriptor);
    }
}
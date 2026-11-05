using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using VisitDreznica.Model.Constants;
using VisitDreznica.Model.Exceptions;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Base;
using VisitDreznica.Services.Database;
using VisitDreznica.Services.Database.Entities;
using VisitDreznica.Services.Security;

namespace VisitDreznica.Services.Users;

public class UserService(
    VisitDreznicaDbContext dbContext,
    IMapper mapper,
    ICurrentUser currentUser,
    IPasswordHasher passwordHasher,
    ISessionService sessionService)
    : BaseCrudService<User, UserResponse, UserSearchObject, UserInsertRequest, UserUpdateRequest>(dbContext, mapper),
      IUserService
{
    protected override string EntityDisplayName => "korisnik";

    // ---------- Admin: pregled ----------

    protected override IQueryable<User> ApplyFilters(IQueryable<User> query, UserSearchObject search)
    {
        if (!string.IsNullOrWhiteSpace(search.Text))
        {
            query = query.Where(x =>
                x.FirstName.Contains(search.Text) ||
                x.LastName.Contains(search.Text) ||
                x.Username.Contains(search.Text) ||
                x.Email.Contains(search.Text));
        }

        if (search.CityId.HasValue)
        {
            query = query.Where(x => x.CityId == search.CityId.Value);
        }

        if (search.RoleId.HasValue)
        {
            query = query.Where(x => x.UserRoles.Any(r => r.RoleId == search.RoleId.Value));
        }

        if (search.IsActive.HasValue)
        {
            query = query.Where(x => x.IsActive == search.IsActive.Value);
        }

        return query;
    }

    protected override IQueryable<User> ApplyOrdering(IQueryable<User> query, UserSearchObject search) =>
        query.OrderBy(x => x.LastName).ThenBy(x => x.FirstName);

    // ---------- Admin: dodavanje ----------

    protected override async Task BeforeInsertAsync(UserInsertRequest request)
    {
        await ValidateUserDataAsync(request.Username, request.Email, request.CityId, excludeId: null);
        await ValidateRolesAsync(request.RoleIds);
    }

    protected override Task AfterMapInsertAsync(User entity, UserInsertRequest request)
    {
        Normalize(entity);

        var (hash, salt) = passwordHasher.HashPassword(request.Password);
        entity.PasswordHash = hash;
        entity.PasswordSalt = salt;
        entity.CreatedAt = DateTime.UtcNow;

        foreach (var roleId in request.RoleIds.Distinct())
        {
            entity.UserRoles.Add(new UserRole { RoleId = roleId });
        }

        return Task.CompletedTask;
    }

    // ---------- Admin: izmjena ----------

    protected override async Task BeforeUpdateAsync(User entity, UserUpdateRequest request)
    {
        await ValidateUserDataAsync(request.Username, request.Email, request.CityId, excludeId: entity.Id);
        await ValidateRolesAsync(request.RoleIds);

        if (entity.Id == currentUser.UserId)
        {
            var adminRoleId = await DbContext.Roles.Where(x => x.Name == AppRoles.Admin).Select(x => x.Id).FirstAsync();

            if (!request.IsActive || !request.RoleIds.Contains(adminRoleId))
            {
                throw new BusinessException("Ne možete deaktivirati vlastiti račun niti sebi ukloniti ulogu administratora.");
            }
        }
    }

    protected override async Task AfterMapUpdateAsync(User entity, UserUpdateRequest request)
    {
        Normalize(entity);
        entity.UpdatedAt = DateTime.UtcNow;

        if (!string.IsNullOrEmpty(request.NewPassword))
        {
            var (hash, salt) = passwordHasher.HashPassword(request.NewPassword);
            entity.PasswordHash = hash;
            entity.PasswordSalt = salt;
        }

        await SyncRolesAsync(entity.Id, request.RoleIds);

        if (!entity.IsActive || !string.IsNullOrEmpty(request.NewPassword))
        {
            await sessionService.RevokeAllForUserAsync(entity.Id);
        }
    }

    // ---------- Admin: brisanje ----------

    protected override Task BeforeDeleteAsync(User entity)
    {
        if (entity.Id == currentUser.UserId)
        {
            throw new BusinessException("Ne možete obrisati vlastiti korisnički račun.");
        }

        return Task.CompletedTask;
    }

    // ---------- Korisnik: vlastiti profil ----------

    public Task<UserResponse> GetProfileAsync() => GetByIdAsync(currentUser.UserId);

    public async Task<UserResponse> UpdateProfileAsync(ProfileUpdateRequest request)
    {
        var user = await FindEntityAsync(currentUser.UserId);
        await ValidateUserDataAsync(user.Username, request.Email, request.CityId, excludeId: user.Id);

        Mapper.Map(request, user);
        Normalize(user);
        user.UpdatedAt = DateTime.UtcNow;

        await DbContext.SaveChangesAsync();

        return await GetByIdAsync(user.Id);
    }

    public async Task ChangePasswordAsync(ChangePasswordRequest request)
    {
        var user = await FindEntityAsync(currentUser.UserId);

        if (!passwordHasher.Verify(request.CurrentPassword, user.PasswordHash, user.PasswordSalt))
        {
            throw new BusinessException("Trenutna lozinka nije ispravna.");
        }

        if (request.CurrentPassword == request.NewPassword)
        {
            throw new BusinessException("Nova lozinka mora biti različita od trenutne.");
        }

        var (hash, salt) = passwordHasher.HashPassword(request.NewPassword);
        user.PasswordHash = hash;
        user.PasswordSalt = salt;
        user.UpdatedAt = DateTime.UtcNow;

        await sessionService.RevokeAllForUserAsync(user.Id, exceptSessionId: currentUser.SessionId);
        await DbContext.SaveChangesAsync();
    }

    // ---------- Pomoćne metode ----------

    private async Task ValidateUserDataAsync(string username, string email, int cityId, int? excludeId)
    {
        var trimmedUsername = username.Trim();
        var trimmedEmail = email.Trim();

        if (await DbContext.Users.AnyAsync(x => x.Username == trimmedUsername && x.Id != excludeId))
        {
            throw new BusinessException($"Korisničko ime '{trimmedUsername}' je zauzeto.");
        }

        if (await DbContext.Users.AnyAsync(x => x.Email == trimmedEmail && x.Id != excludeId))
        {
            throw new BusinessException("Korisnik s ovom e-mail adresom već postoji.");
        }

        if (!await DbContext.Cities.AnyAsync(x => x.Id == cityId))
        {
            throw new BusinessException("Odabrani grad ne postoji.");
        }
    }

    private async Task ValidateRolesAsync(List<int> roleIds)
    {
        var distinctIds = roleIds.Distinct().ToList();
        var existingCount = await DbContext.Roles.CountAsync(x => distinctIds.Contains(x.Id));

        if (distinctIds.Count == 0 || existingCount != distinctIds.Count)
        {
            throw new BusinessException("Odaberite barem jednu postojeću ulogu.");
        }
    }

    private async Task SyncRolesAsync(int userId, List<int> roleIds)
    {
        var requestedIds = roleIds.Distinct().ToList();
        var current = await DbContext.UserRoles.Where(x => x.UserId == userId).ToListAsync();

        DbContext.UserRoles.RemoveRange(current.Where(x => !requestedIds.Contains(x.RoleId)));

        var currentIds = current.Select(x => x.RoleId).ToHashSet();
        foreach (var roleId in requestedIds.Where(id => !currentIds.Contains(id)))
        {
            DbContext.UserRoles.Add(new UserRole { UserId = userId, RoleId = roleId });
        }
    }

    private static void Normalize(User user)
    {
        user.FirstName = user.FirstName.Trim();
        user.LastName = user.LastName.Trim();
        user.Email = user.Email.Trim();
        user.Username = user.Username.Trim();
        user.PhoneNumber = string.IsNullOrWhiteSpace(user.PhoneNumber) ? null : user.PhoneNumber.Trim();
    }
}
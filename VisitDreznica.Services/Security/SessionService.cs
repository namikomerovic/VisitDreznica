using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Caching.Memory;
using VisitDreznica.Services.Database;

namespace VisitDreznica.Services.Security;

public class SessionService(VisitDreznicaDbContext dbContext, IMemoryCache cache) : ISessionService
{
    private static readonly TimeSpan CacheDuration = TimeSpan.FromMinutes(5);

    public async Task<bool> IsActiveAsync(Guid sessionId)
    {
        return await cache.GetOrCreateAsync(CacheKey(sessionId), async entry =>
        {
            entry.AbsoluteExpirationRelativeToNow = CacheDuration;
            var now = DateTime.UtcNow;

            return await dbContext.UserSessions
                .AnyAsync(x => x.Id == sessionId && x.RevokedAt == null && x.ExpiresAt > now);
        });
    }

    public async Task RevokeAsync(Guid sessionId)
    {
        var session = await dbContext.UserSessions.FirstOrDefaultAsync(x => x.Id == sessionId);

        if (session is { RevokedAt: null })
        {
            session.RevokedAt = DateTime.UtcNow;
            await dbContext.SaveChangesAsync();
        }

        cache.Remove(CacheKey(sessionId));
    }

    private static string CacheKey(Guid sessionId) => $"session:{sessionId}";
}
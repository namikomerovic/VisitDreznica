using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using VisitDreznica.Model.Exceptions;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Base;
using VisitDreznica.Services.Database;
using VisitDreznica.Services.Database.Entities;
using VisitDreznica.Services.Security;

namespace VisitDreznica.Services.Notifications;

public class NotificationService(VisitDreznicaDbContext dbContext, IMapper mapper, ICurrentUser currentUser)
    : BaseReadService<Notification, NotificationResponse, NotificationSearchObject>(dbContext, mapper), INotificationService
{
    private const string NotFoundMessage = "Tražena obavijest ne postoji.";

    protected override string EntityDisplayName => "obavijest";

    protected override IQueryable<NotificationResponse> Project(IQueryable<Notification> query) =>
        query.Select(x => new NotificationResponse
        {
            Id = x.Id,
            Title = x.Title,
            Message = x.Message,
            Type = x.Type,
            ReservationId = x.ReservationId,
            IsRead = x.IsRead,
            CreatedAt = x.CreatedAt,
            ReadAt = x.ReadAt
        });

    protected override IQueryable<Notification> ApplyFilters(IQueryable<Notification> query, NotificationSearchObject search)
    {
        var userId = currentUser.UserId;
        query = query.Where(x => x.UserId == userId);

        if (search.OnlyUnread)
        {
            query = query.Where(x => !x.IsRead);
        }

        return query;
    }

    protected override IQueryable<Notification> ApplyOrdering(IQueryable<Notification> query, NotificationSearchObject search) =>
        query.OrderByDescending(x => x.CreatedAt).ThenByDescending(x => x.Id);

    public override async Task<NotificationResponse> GetByIdAsync(int id)
    {
        var userId = currentUser.UserId;

        return await Project(DbContext.Notifications.AsNoTracking().Where(x => x.Id == id && x.UserId == userId))
                   .FirstOrDefaultAsync()
               ?? throw new NotFoundException(NotFoundMessage);
    }

    public async Task<UnreadCountResponse> GetUnreadCountAsync()
    {
        var userId = currentUser.UserId;

        return new UnreadCountResponse
        {
            Count = await DbContext.Notifications.CountAsync(x => x.UserId == userId && !x.IsRead)
        };
    }

    public async Task MarkAsReadAsync(int id)
    {
        var userId = currentUser.UserId;

        var notification = await DbContext.Notifications.FirstOrDefaultAsync(x => x.Id == id && x.UserId == userId)
                           ?? throw new NotFoundException(NotFoundMessage);

        if (notification.IsRead)
        {
            return;
        }

        notification.IsRead = true;
        notification.ReadAt = DateTime.UtcNow;

        await DbContext.SaveChangesAsync();
    }

    public async Task MarkAllAsReadAsync()
    {
        var userId = currentUser.UserId;
        var now = DateTime.UtcNow;

        await DbContext.Notifications
            .Where(x => x.UserId == userId && !x.IsRead)
            .ExecuteUpdateAsync(setters => setters
                .SetProperty(x => x.IsRead, true)
                .SetProperty(x => x.ReadAt, now));
    }

    public async Task DeleteAsync(int id)
    {
        var userId = currentUser.UserId;

        var deleted = await DbContext.Notifications
            .Where(x => x.Id == id && x.UserId == userId)
            .ExecuteDeleteAsync();

        if (deleted == 0)
        {
            throw new NotFoundException(NotFoundMessage);
        }
    }
}
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Base;

namespace VisitDreznica.Services.Notifications;

public interface INotificationService : IReadService<NotificationResponse, NotificationSearchObject>
{
    Task<UnreadCountResponse> GetUnreadCountAsync();
    Task MarkAsReadAsync(int id);
    Task MarkAllAsReadAsync();
    Task DeleteAsync(int id);
}
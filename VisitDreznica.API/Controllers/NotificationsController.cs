using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Notifications;

namespace VisitDreznica.API.Controllers;

[ApiController]
[Route("[controller]")]
[Authorize]
public class NotificationsController(INotificationService notificationService) : ControllerBase
{
    [HttpGet]
    public Task<PageResult<NotificationResponse>> Get([FromQuery] NotificationSearchObject search) =>
        notificationService.GetPagedAsync(search);

    [HttpGet("{id:int}")]
    public Task<NotificationResponse> GetById(int id) => notificationService.GetByIdAsync(id);

    [HttpGet("unread-count")]
    public Task<UnreadCountResponse> GetUnreadCount() => notificationService.GetUnreadCountAsync();

    [HttpPost("{id:int}/read")]
    public async Task<IActionResult> MarkAsRead(int id)
    {
        await notificationService.MarkAsReadAsync(id);
        return NoContent();
    }

    [HttpPost("read-all")]
    public async Task<IActionResult> MarkAllAsRead()
    {
        await notificationService.MarkAllAsReadAsync();
        return NoContent();
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        await notificationService.DeleteAsync(id);
        return NoContent();
    }
}
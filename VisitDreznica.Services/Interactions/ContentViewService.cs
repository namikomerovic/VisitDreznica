using Microsoft.EntityFrameworkCore;
using VisitDreznica.Model.Requests;
using VisitDreznica.Services.Database;
using VisitDreznica.Services.Database.Entities;
using VisitDreznica.Services.Security;

namespace VisitDreznica.Services.Interactions;

public class ContentViewService(VisitDreznicaDbContext dbContext, ICurrentUser currentUser) : IContentViewService
{
    private static readonly TimeSpan DeduplicationWindow = TimeSpan.FromMinutes(30);

    public async Task RecordAsync(ItemReferenceRequest item)
    {
        var userId = currentUser.UserId;
        var now = DateTime.UtcNow;
        var windowStart = now - DeduplicationWindow;

        var viewedRecently = await dbContext.ContentViews
            .Where(ItemTargets.Matches<ContentView>(item.ItemType, item.ItemId))
            .AnyAsync(x => x.UserId == userId && x.ViewedAt >= windowStart);

        if (viewedRecently)
        {
            return;
        }

        await ItemTargets.EnsureExistsAsync(dbContext, item.ItemType, item.ItemId);

        var view = new ContentView { UserId = userId, ViewedAt = now };
        ItemTargets.Assign(view, item.ItemType, item.ItemId);
        dbContext.ContentViews.Add(view);

        await dbContext.SaveChangesAsync();
    }
}
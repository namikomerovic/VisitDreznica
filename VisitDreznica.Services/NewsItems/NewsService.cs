using MapsterMapper;
using VisitDreznica.Model.Constants;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Base;
using VisitDreznica.Services.Database;
using VisitDreznica.Services.Database.Entities;
using VisitDreznica.Services.Security;

namespace VisitDreznica.Services.NewsItems;

public class NewsService(VisitDreznicaDbContext dbContext, IMapper mapper, ICurrentUser currentUser)
    : BaseCrudService<News, NewsResponse, NewsSearchObject, NewsUpsertRequest, NewsUpsertRequest>(dbContext, mapper),
      INewsService
{
    protected override string EntityDisplayName => "obavijest";

    protected override IQueryable<News> ApplyFilters(IQueryable<News> query, NewsSearchObject search)
    {
        if (!currentUser.IsInRole(AppRoles.Admin))
        {
            var now = DateTime.UtcNow;
            query = query.Where(x => x.PublishedAt <= now);
        }

        if (!string.IsNullOrWhiteSpace(search.Title))
        {
            query = query.Where(x => x.Title.Contains(search.Title));
        }

        if (search.From.HasValue)
        {
            var from = search.From.Value.ToUniversalTime();
            query = query.Where(x => x.PublishedAt >= from);
        }

        if (search.To.HasValue)
        {
            var to = search.To.Value.ToUniversalTime();
            query = query.Where(x => x.PublishedAt <= to);
        }

        return query;
    }

    protected override IQueryable<News> ApplyOrdering(IQueryable<News> query, NewsSearchObject search) =>
        query.OrderByDescending(x => x.PublishedAt);

    protected override Task AfterMapInsertAsync(News entity, NewsUpsertRequest request)
    {
        entity.PublishedAt = entity.PublishedAt.ToUniversalTime();
        entity.CreatedAt = DateTime.UtcNow;
        entity.CreatedByUserId = currentUser.UserId;
        return Task.CompletedTask;
    }

    protected override Task AfterMapUpdateAsync(News entity, NewsUpsertRequest request)
    {
        entity.PublishedAt = entity.PublishedAt.ToUniversalTime();
        entity.UpdatedAt = DateTime.UtcNow;
        return Task.CompletedTask;
    }
}
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

namespace VisitDreznica.Services.Activities;

public class ActivityService(VisitDreznicaDbContext dbContext, IMapper mapper, ICurrentUser currentUser)
    : BaseCrudService<Activity, ActivityResponse, ActivitySearchObject, ActivityUpsertRequest, ActivityUpsertRequest>(dbContext, mapper),
      IActivityService
{
    protected override string EntityDisplayName => "aktivnost";

    protected override IQueryable<Activity> ApplyFilters(IQueryable<Activity> query, ActivitySearchObject search)
    {
        if (!currentUser.IsInRole(AppRoles.Admin))
        {
            query = query.Where(x => x.IsActive);
        }
        else if (search.IsActive.HasValue)
        {
            query = query.Where(x => x.IsActive == search.IsActive.Value);
        }

        if (!string.IsNullOrWhiteSpace(search.Name))
        {
            query = query.Where(x => x.Name.Contains(search.Name));
        }

        if (search.ActivityCategoryId.HasValue)
        {
            query = query.Where(x => x.ActivityCategoryId == search.ActivityCategoryId.Value);
        }

        return query;
    }

    protected override IQueryable<Activity> ApplyOrdering(IQueryable<Activity> query, ActivitySearchObject search) =>
        query.OrderBy(x => x.Name);

    protected override Task BeforeInsertAsync(ActivityUpsertRequest request) => ValidateAsync(request, excludeId: null);

    protected override Task BeforeUpdateAsync(Activity entity, ActivityUpsertRequest request) => ValidateAsync(request, excludeId: entity.Id);

    protected override Task AfterMapInsertAsync(Activity entity, ActivityUpsertRequest request)
    {
        entity.CreatedAt = DateTime.UtcNow;
        return Task.CompletedTask;
    }

    protected override Task AfterMapUpdateAsync(Activity entity, ActivityUpsertRequest request)
    {
        entity.UpdatedAt = DateTime.UtcNow;
        return Task.CompletedTask;
    }

    private async Task ValidateAsync(ActivityUpsertRequest request, int? excludeId)
    {
        var trimmedName = request.Name.Trim();

        if (await DbContext.Activities.AnyAsync(x => x.Name == trimmedName && x.Id != excludeId))
        {
            throw new BusinessException($"Aktivnost s nazivom '{trimmedName}' već postoji.");
        }

        if (!await DbContext.ActivityCategories.AnyAsync(x => x.Id == request.ActivityCategoryId))
        {
            throw new BusinessException("Odabrana kategorija aktivnosti ne postoji.");
        }

        if (excludeId.HasValue)
        {
            var largestSlot = await DbContext.ActivitySlots
                .Where(x => x.ActivityId == excludeId.Value && x.StartTime > DateTime.UtcNow)
                .MaxAsync(x => (int?)x.Capacity);

            if (largestSlot > request.MaxParticipants)
            {
                throw new BusinessException(
                    $"Maksimalan broj učesnika ne može biti manji od {largestSlot}, jer postoje budući termini s tim kapacitetom.");
            }
        }
    }
}
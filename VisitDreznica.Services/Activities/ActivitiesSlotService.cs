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

public class ActivitySlotService(VisitDreznicaDbContext dbContext, IMapper mapper, ICurrentUser currentUser)
    : BaseCrudService<ActivitySlot, ActivitySlotResponse, ActivitySlotSearchObject, ActivitySlotInsertRequest, ActivitySlotUpdateRequest>(dbContext, mapper),
      IActivitySlotService
{
    protected override string EntityDisplayName => "termin";

    protected override IQueryable<ActivitySlot> ApplyFilters(IQueryable<ActivitySlot> query, ActivitySlotSearchObject search)
    {
        if (!currentUser.IsInRole(AppRoles.Admin))
        {
            query = query.Where(x => x.Activity.IsActive);
        }

        if (search.ActivityId.HasValue)
        {
            query = query.Where(x => x.ActivityId == search.ActivityId.Value);
        }

        if (search.GuideId.HasValue)
        {
            query = query.Where(x => x.GuideId == search.GuideId.Value);
        }

        if (search.From.HasValue)
        {
            var from = search.From.Value.ToUniversalTime();
            query = query.Where(x => x.StartTime >= from);
        }

        if (search.To.HasValue)
        {
            var to = search.To.Value.ToUniversalTime();
            query = query.Where(x => x.StartTime <= to);
        }

        if (search.OnlyUpcoming)
        {
            var now = DateTime.UtcNow;
            query = query.Where(x => x.StartTime > now);
        }

        return query;
    }

    protected override IQueryable<ActivitySlot> ApplyOrdering(IQueryable<ActivitySlot> query, ActivitySlotSearchObject search) =>
        query.OrderBy(x => x.StartTime);

    protected override Task BeforeUpdateAsync(ActivitySlot entity, ActivitySlotUpdateRequest request)
    {
        if (entity.StartTime <= DateTime.UtcNow)
        {
            throw new BusinessException("Termin koji je već počeo ili završio ne može se mijenjati.");
        }

        return Task.CompletedTask;
    }

    protected override async Task AfterMapInsertAsync(ActivitySlot entity, ActivitySlotInsertRequest request)
    {
        entity.CreatedAt = DateTime.UtcNow;
        await PrepareAndValidateAsync(entity);
    }

    protected override Task AfterMapUpdateAsync(ActivitySlot entity, ActivitySlotUpdateRequest request) =>
        PrepareAndValidateAsync(entity);

    private async Task PrepareAndValidateAsync(ActivitySlot slot)
    {
        var activity = await DbContext.Activities
                           .Where(x => x.Id == slot.ActivityId)
                           .Select(x => new { x.DurationMinutes, x.MaxParticipants })
                           .FirstOrDefaultAsync()
                       ?? throw new BusinessException("Odabrana aktivnost ne postoji.");

        if (!await DbContext.Guides.AnyAsync(x => x.Id == slot.GuideId))
        {
            throw new BusinessException("Odabrani vodič ne postoji.");
        }

        slot.StartTime = slot.StartTime.ToUniversalTime();
        slot.EndTime = slot.StartTime.AddMinutes(activity.DurationMinutes);

        if (slot.StartTime <= DateTime.UtcNow)
        {
            throw new BusinessException("Termin mora biti u budućnosti.");
        }

        if (slot.Capacity > activity.MaxParticipants)
        {
            throw new BusinessException($"Kapacitet termina ne može biti veći od maksimuma aktivnosti ({activity.MaxParticipants} osoba).");
        }

        var guideIsBusy = await DbContext.ActivitySlots.AnyAsync(x =>
            x.GuideId == slot.GuideId &&
            x.Id != slot.Id &&
            x.StartTime < slot.EndTime &&
            slot.StartTime < x.EndTime);

        if (guideIsBusy)
        {
            throw new BusinessException("Odabrani vodič u tom periodu već vodi drugi termin.");
        }
    }
}
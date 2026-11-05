using MapsterMapper;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Base;
using VisitDreznica.Services.Database;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Lookups;

public class GuideService(VisitDreznicaDbContext dbContext, IMapper mapper)
    : BaseCrudService<Guide, GuideResponse, GuideSearchObject, GuideUpsertRequest, GuideUpsertRequest>(dbContext, mapper),
      IGuideService
{
    protected override string EntityDisplayName => "vodič";

    protected override IQueryable<Guide> ApplyFilters(IQueryable<Guide> query, GuideSearchObject search)
    {
        if (!string.IsNullOrWhiteSpace(search.Name))
        {
            query = query.Where(x => x.FirstName.Contains(search.Name) || x.LastName.Contains(search.Name));
        }

        return query;
    }

    protected override IQueryable<Guide> ApplyOrdering(IQueryable<Guide> query, GuideSearchObject search) =>
        query.OrderBy(x => x.LastName).ThenBy(x => x.FirstName);
}
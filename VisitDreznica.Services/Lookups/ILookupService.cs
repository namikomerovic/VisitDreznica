using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Base;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Lookups;

public interface ILookupService<TEntity>
    : ICrudService<LookupResponse, LookupSearchObject, LookupUpsertRequest, LookupUpsertRequest>
    where TEntity : LookupEntity;
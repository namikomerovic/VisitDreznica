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

namespace VisitDreznica.Services.Equipments;

public class EquipmentService(VisitDreznicaDbContext dbContext, IMapper mapper, ICurrentUser currentUser)
    : BaseCrudService<Equipment, EquipmentResponse, EquipmentSearchObject, EquipmentUpsertRequest, EquipmentUpsertRequest>(dbContext, mapper),
      IEquipmentService
{
    protected override string EntityDisplayName => "oprema";

    protected override IQueryable<Equipment> ApplyFilters(IQueryable<Equipment> query, EquipmentSearchObject search)
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

        if (search.EquipmentTypeId.HasValue)
        {
            query = query.Where(x => x.EquipmentTypeId == search.EquipmentTypeId.Value);
        }

        return query;
    }

    protected override IQueryable<Equipment> ApplyOrdering(IQueryable<Equipment> query, EquipmentSearchObject search) =>
        query.OrderBy(x => x.Name);

    protected override Task BeforeInsertAsync(EquipmentUpsertRequest request) => ValidateAsync(request, excludeId: null);

    protected override Task BeforeUpdateAsync(Equipment entity, EquipmentUpsertRequest request) => ValidateAsync(request, excludeId: entity.Id);

    protected override Task AfterMapInsertAsync(Equipment entity, EquipmentUpsertRequest request)
    {
        entity.CreatedAt = DateTime.UtcNow;
        return Task.CompletedTask;
    }

    protected override Task AfterMapUpdateAsync(Equipment entity, EquipmentUpsertRequest request)
    {
        entity.UpdatedAt = DateTime.UtcNow;
        return Task.CompletedTask;
    }

    private async Task ValidateAsync(EquipmentUpsertRequest request, int? excludeId)
    {
        if (request.AdditionalHourPrice > request.FirstHourPrice)
        {
            throw new BusinessException("Cijena svakog sljedećeg sata ne može biti veća od cijene prvog sata.");
        }

        if (request.FullDayPrice < request.FirstHourPrice)
        {
            throw new BusinessException("Cijena za cijeli dan ne može biti manja od cijene prvog sata.");
        }

        var trimmedName = request.Name.Trim();

        if (await DbContext.Equipment.AnyAsync(x => x.Name == trimmedName && x.Id != excludeId))
        {
            throw new BusinessException($"Oprema s nazivom '{trimmedName}' već postoji.");
        }

        if (!await DbContext.EquipmentTypes.AnyAsync(x => x.Id == request.EquipmentTypeId))
        {
            throw new BusinessException("Odabrani tip opreme ne postoji.");
        }
    }
}
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Base;

namespace VisitDreznica.Services.Equipments;

public interface IEquipmentService
    : ICrudService<EquipmentResponse, EquipmentSearchObject, EquipmentUpsertRequest, EquipmentUpsertRequest>;
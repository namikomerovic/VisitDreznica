using VisitDreznica.API.Controllers.Base;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Database.Entities;
using VisitDreznica.Services.Equipments;
using VisitDreznica.Services.Images;

namespace VisitDreznica.API.Controllers;

public class EquipmentController(IEquipmentService service, IEntityImageService<Equipment> imageService)
    : ImageCrudController<Equipment, EquipmentResponse, EquipmentSearchObject, EquipmentUpsertRequest, EquipmentUpsertRequest>(service, imageService);
using VisitDreznica.API.Controllers.Base;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Database.Entities;
using VisitDreznica.Services.Images;
using VisitDreznica.Services.Rooms;

namespace VisitDreznica.API.Controllers;

public class RoomsController(IRoomService service, IGalleryImageService<Room, RoomImage> galleryService)
    : GalleryCrudController<Room, RoomImage, RoomResponse, RoomSearchObject, RoomUpsertRequest, RoomUpsertRequest>(service, galleryService);
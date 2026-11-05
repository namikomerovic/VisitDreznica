using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Base;

namespace VisitDreznica.Services.Rooms;

public interface IRoomService : ICrudService<RoomResponse, RoomSearchObject, RoomUpsertRequest, RoomUpsertRequest>;
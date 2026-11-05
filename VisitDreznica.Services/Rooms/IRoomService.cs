using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Base;

namespace VisitDreznica.Services.Rooms;

public interface IRoomService : ICrudService<RoomResponse, RoomSearchObject, RoomUpsertRequest, RoomUpsertRequest>
{
    Task<RoomImageResponse> AddImageAsync(int roomId, Stream content, long length, string declaredContentType);
    Task<FileContent> GetImageAsync(int imageId);
    Task SetCoverImageAsync(int imageId);
    Task DeleteImageAsync(int imageId);
}
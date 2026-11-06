using VisitDreznica.Model.Enums;
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;

namespace VisitDreznica.Services.Interactions;

public interface IFavoriteService
{
    Task<List<FavoriteResponse>> GetMineAsync(ItemType? itemType);
    Task<FavoriteResponse> AddAsync(ItemReferenceRequest item);
    Task RemoveAsync(ItemReferenceRequest item);
}
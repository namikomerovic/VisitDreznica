using Mapster;
using VisitDreznica.Model.Responses;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Rooms;

public class RoomMappings : IRegister
{
    public void Register(TypeAdapterConfig config)
    {
        config.NewConfig<Room, RoomResponse>()
            .Map(dest => dest.CoverImageId,
                src => src.Images.Where(i => i.IsCover).Select(i => (int?)i.Id).FirstOrDefault())
            .Map(dest => dest.Images,
                src => src.Images
                    .OrderBy(i => i.DisplayOrder)
                    .Select(i => new RoomImageResponse { Id = i.Id, IsCover = i.IsCover, DisplayOrder = i.DisplayOrder })
                    .ToList())
            .Map(dest => dest.Amenities,
                src => src.RoomAmenities
                    .OrderBy(a => a.Amenity.Name)
                    .Select(a => new LookupResponse { Id = a.Amenity.Id, Name = a.Amenity.Name, Description = a.Amenity.Description })
                    .ToList());
    }
}
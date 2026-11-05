using Mapster;
using VisitDreznica.Model.Responses;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Places;

public class PlaceMappings : IRegister
{
    public void Register(TypeAdapterConfig config)
    {
        config.NewConfig<Place, PlaceResponse>()
            .Map(dest => dest.CoverImageId,
                src => src.Images.Where(i => i.IsCover).Select(i => (int?)i.Id).FirstOrDefault())
            .Map(dest => dest.Images,
                src => src.Images
                    .OrderBy(i => i.DisplayOrder)
                    .Select(i => new GalleryImageResponse { Id = i.Id, IsCover = i.IsCover, DisplayOrder = i.DisplayOrder })
                    .ToList());
    }
}
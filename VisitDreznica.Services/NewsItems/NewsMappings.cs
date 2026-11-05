using Mapster;
using VisitDreznica.Model.Responses;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.NewsItems;

public class NewsMappings : IRegister
{
    public void Register(TypeAdapterConfig config)
    {
        config.NewConfig<News, NewsResponse>()
            .Map(dest => dest.HasImage, src => src.ImageData != null)
            .Map(dest => dest.IsPublished, src => src.PublishedAt <= DateTime.UtcNow)
            .Map(dest => dest.CreatedByFullName, src => src.CreatedByUser.FirstName + " " + src.CreatedByUser.LastName);
    }
}
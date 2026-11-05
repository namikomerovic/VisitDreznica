using Mapster;
using VisitDreznica.Model.Responses;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Equipments;

public class EquipmentMappings : IRegister
{
    public void Register(TypeAdapterConfig config)
    {
        config.NewConfig<Equipment, EquipmentResponse>()
            .Map(dest => dest.HasImage, src => src.ImageData != null);
    }
}
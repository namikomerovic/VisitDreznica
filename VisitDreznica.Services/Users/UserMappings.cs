using Mapster;
using VisitDreznica.Model.Responses;
using VisitDreznica.Services.Database.Entities;

namespace VisitDreznica.Services.Users;

public class UserMappings : IRegister
{
    public void Register(TypeAdapterConfig config)
    {
        config.NewConfig<User, UserResponse>()
            .Map(dest => dest.HasImage, src => src.ImageData != null)
            .Map(dest => dest.Roles, src => src.UserRoles.Select(r => r.Role.Name).ToList());
    }
}
using VisitDreznica.Model.Requests;
using VisitDreznica.Model.Responses;
using VisitDreznica.Model.SearchObjects;
using VisitDreznica.Services.Base;

namespace VisitDreznica.Services.Users;

public interface IUserService : ICrudService<UserResponse, UserSearchObject, UserInsertRequest, UserUpdateRequest>
{
    Task<UserResponse> GetProfileAsync();
    Task<UserResponse> UpdateProfileAsync(ProfileUpdateRequest request);
    Task ChangePasswordAsync(ChangePasswordRequest request);
}
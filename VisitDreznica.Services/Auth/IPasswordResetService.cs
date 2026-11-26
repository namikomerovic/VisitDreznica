using VisitDreznica.Model.Requests;

namespace VisitDreznica.Services.Auth;

public interface IPasswordResetService
{
    Task RequestAsync(PasswordResetRequest request);
    Task ConfirmAsync(PasswordResetConfirmRequest request);
}

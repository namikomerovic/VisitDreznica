import '../api/api_client.dart';

class PasswordResetService {
  PasswordResetService(this._api);

  final ApiClient _api;

  Future<void> requestCode(String email) async {
    await _api.post('Auth/password-reset/request', body: {'email': email.trim()});
  }

  Future<void> confirm({required String email, required String code, required String newPassword}) async {
    await _api.post('Auth/password-reset/confirm', body: {
      'email': email.trim(),
      'code': code.trim(),
      'newPassword': newPassword,
      'newPasswordConfirmation': newPassword,
    });
  }
}

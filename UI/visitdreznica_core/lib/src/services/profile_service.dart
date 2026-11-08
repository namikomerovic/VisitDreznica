import 'dart:typed_data';

import '../api/api_client.dart';
import '../models/user.dart';

class ProfileService {
  ProfileService(this._api);

  final ApiClient _api;

  Future<AppUser> get() async => AppUser.fromJson(await _api.get('Profile') as Map<String, dynamic>);

  Future<AppUser> update({
    required String firstName,
    required String lastName,
    required String email,
    String? phoneNumber,
    required int cityId,
  }) async =>
      AppUser.fromJson(await _api.put('Profile', body: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'cityId': cityId,
      }) as Map<String, dynamic>);

  Future<void> changePassword({required String currentPassword, required String newPassword}) async {
    await _api.put('Profile/password', body: {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'newPasswordConfirmation': newPassword,
    });
  }

  Future<void> setImage(Uint8List bytes, {required String fileName, required String contentType}) async {
    await _api.putFile('Profile/image', field: 'file', bytes: bytes, fileName: fileName, contentType: contentType);
  }

  Future<void> deleteImage() async {
    await _api.delete('Profile/image');
  }

  String imageUrl({int version = 0}) => '${_api.url('Profile/image')}?v=$version';
}
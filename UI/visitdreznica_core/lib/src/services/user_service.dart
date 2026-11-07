import '../api/api_client.dart';
import '../models/page_result.dart';
import '../models/user.dart';

class UserService {
  UserService(this._api);

  final ApiClient _api;

  Future<PageResult<AppUser>> getPage(UserSearch search, {int page = 1, int pageSize = 20}) async {
    final json = await _api.get('Users', query: search.toQuery(page: page, pageSize: pageSize));
    return PageResult.fromJson(json, AppUser.fromJson);
  }

  Future<AppUser> getById(int id) async => AppUser.fromJson(await _api.get('Users/$id') as Map<String, dynamic>);

  Future<AppUser> insert(UserUpsertRequest request) async =>
      AppUser.fromJson(await _api.post('Users', body: request.toInsertJson()) as Map<String, dynamic>);

  Future<AppUser> update(int id, UserUpsertRequest request) async =>
      AppUser.fromJson(await _api.put('Users/$id', body: request.toUpdateJson()) as Map<String, dynamic>);

  Future<void> delete(int id) async {
    await _api.delete('Users/$id');
  }

  String imageUrl(int id) => _api.url('Users/$id/image');
}
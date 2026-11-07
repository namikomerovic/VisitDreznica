import '../api/api_client.dart';
import '../models/activity.dart';
import '../models/page_result.dart';

class GuideService {
  GuideService(this._api);

  final ApiClient _api;

  Future<List<Guide>> getAll() async => (await getPage(pageSize: 100)).items;

  Future<PageResult<Guide>> getPage({String? name, int page = 1, int pageSize = 20}) async {
    final trimmed = name?.trim();
    final json = await _api.get('Guides', query: {
      'page': page,
      'pageSize': pageSize,
      if (trimmed != null && trimmed.isNotEmpty) 'name': trimmed,
    });
    return PageResult.fromJson(json, Guide.fromJson);
  }

  Future<void> insert({required String firstName, required String lastName, String? phoneNumber}) async {
    await _api.post('Guides', body: {'firstName': firstName, 'lastName': lastName, 'phoneNumber': phoneNumber});
  }

  Future<void> update(int id, {required String firstName, required String lastName, String? phoneNumber}) async {
    await _api.put('Guides/$id', body: {'firstName': firstName, 'lastName': lastName, 'phoneNumber': phoneNumber});
  }

  Future<void> delete(int id) async {
    await _api.delete('Guides/$id');
  }
}
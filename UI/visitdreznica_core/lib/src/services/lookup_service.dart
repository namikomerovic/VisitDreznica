import '../api/api_client.dart';
import '../models/lookup.dart';
import '../models/page_result.dart';

class LookupService {
  LookupService(this._api, this._resource);

  final ApiClient _api;
  final String _resource;

  Future<List<LookupItem>> getAll() async => (await getPage(pageSize: 100)).items;

  Future<PageResult<LookupItem>> getPage({String? name, int page = 1, int pageSize = 20}) async {
    final trimmed = name?.trim();
    final json = await _api.get(_resource, query: {
      'page': page,
      'pageSize': pageSize,
      if (trimmed != null && trimmed.isNotEmpty) 'name': trimmed,
    });
    return PageResult.fromJson(json, LookupItem.fromJson);
  }

  Future<void> insert({required String name, String? description}) async {
    await _api.post(_resource, body: {'name': name, 'description': description});
  }

  Future<void> update(int id, {required String name, String? description}) async {
    await _api.put('$_resource/$id', body: {'name': name, 'description': description});
  }

  Future<void> delete(int id) async {
    await _api.delete('$_resource/$id');
  }
}
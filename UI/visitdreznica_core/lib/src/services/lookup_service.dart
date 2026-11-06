import '../api/api_client.dart';
import '../models/lookup.dart';
import '../models/page_result.dart';

class LookupService {
  LookupService(this._api, this._resource);

  final ApiClient _api;
  final String _resource;

  Future<List<LookupItem>> getAll() async {
    final json = await _api.get(_resource, query: {'page': 1, 'pageSize': 100});
    return PageResult.fromJson(json, LookupItem.fromJson).items;
  }
}
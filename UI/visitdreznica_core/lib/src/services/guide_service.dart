import '../api/api_client.dart';
import '../models/activity.dart';
import '../models/page_result.dart';

class GuideService {
  GuideService(this._api);

  final ApiClient _api;

  Future<List<Guide>> getAll() async {
    final json = await _api.get('Guides', query: {'page': 1, 'pageSize': 100});
    return PageResult.fromJson(json, Guide.fromJson).items;
  }
}
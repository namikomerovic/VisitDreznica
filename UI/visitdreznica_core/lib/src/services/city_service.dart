import '../api/api_client.dart';
import '../models/city.dart';
import '../models/page_result.dart';

class CityService {
  CityService(this._api);

  final ApiClient _api;

  Future<List<City>> getAll() async => (await getPage(pageSize: 100)).items;

  Future<PageResult<City>> getPage({String? name, int? countryId, int page = 1, int pageSize = 20}) async {
    final trimmed = name?.trim();
    final json = await _api.get('Cities', query: {
      'page': page,
      'pageSize': pageSize,
      if (trimmed != null && trimmed.isNotEmpty) 'name': trimmed,
      if (countryId != null) 'countryId': countryId,
    });
    return PageResult.fromJson(json, City.fromJson);
  }

    Future<List<City>> getForRegistration() async {
    final json = await _api.get('Auth/cities', query: {'page': 1, 'pageSize': 100});
    return PageResult.fromJson(json, City.fromJson).items..sort((a, b) => a.name.compareTo(b.name));
  }

  Future<void> insert({required String name, String? postalCode, required int countryId}) async {
    await _api.post('Cities', body: {'name': name, 'postalCode': postalCode, 'countryId': countryId});
  }

  Future<void> update(int id, {required String name, String? postalCode, required int countryId}) async {
    await _api.put('Cities/$id', body: {'name': name, 'postalCode': postalCode, 'countryId': countryId});
  }

  Future<void> delete(int id) async {
    await _api.delete('Cities/$id');
  }
}
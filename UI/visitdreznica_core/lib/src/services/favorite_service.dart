import '../api/api_client.dart';
import '../models/favorite.dart';
import '../models/item_type.dart';

class FavoriteService {
  FavoriteService(this._api);

  final ApiClient _api;

  Future<List<Favorite>> getMine({ItemType? itemType}) async {
    final json = await _api.get('Favorites', query: {
      if (itemType != null) 'itemType': itemType.value,
    }) as List<dynamic>;

    return json.map((x) => Favorite.fromJson(x as Map<String, dynamic>)).toList();
  }

  Future<Favorite> add(ItemType itemType, int itemId) async => Favorite.fromJson(
        await _api.post('Favorites', body: {'itemType': itemType.value, 'itemId': itemId}) as Map<String, dynamic>,
      );

  Future<void> remove(ItemType itemType, int itemId) async {
    await _api.delete('Favorites', query: {'itemType': itemType.value, 'itemId': itemId});
  }
}
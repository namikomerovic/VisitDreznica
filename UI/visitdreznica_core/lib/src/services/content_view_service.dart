import '../api/api_client.dart';
import '../models/item_type.dart';

class ContentViewService {
  ContentViewService(this._api);

  final ApiClient _api;

  Future<void> record(ItemType itemType, int itemId) async {
    await _api.post('ContentViews', body: {'itemType': itemType.value, 'itemId': itemId});
  }
}
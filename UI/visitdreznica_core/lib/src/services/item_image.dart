import '../api/api_client.dart';
import '../models/item_type.dart';

/// Adresa naslovne slike stavke, ili null kad stavka nema sliku.
String? itemImageUrl(ApiClient api, ItemType type, int itemId, {int? coverImageId, required bool hasImage}) {
  if (!hasImage) return null;

  return switch (type) {
    ItemType.room => coverImageId == null ? null : api.url('Rooms/images/$coverImageId'),
    ItemType.place => coverImageId == null ? null : api.url('Places/images/$coverImageId'),
    ItemType.equipment => api.url('Equipment/$itemId/image'),
    ItemType.activity => api.url('Activities/$itemId/image'),
  };
}

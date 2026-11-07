import 'dart:typed_data';

import '../api/api_client.dart';
import '../models/page_result.dart';
import '../models/place.dart';

class PlaceService {
  PlaceService(this._api);

  final ApiClient _api;

  Future<PageResult<Place>> getPage(PlaceSearch search, {int page = 1, int pageSize = 20}) async {
    final json = await _api.get('Places', query: search.toQuery(page: page, pageSize: pageSize));
    return PageResult.fromJson(json, Place.fromJson);
  }

  Future<Place> getById(int id) async => Place.fromJson(await _api.get('Places/$id') as Map<String, dynamic>);

  Future<Place> insert(PlaceUpsertRequest request) async =>
      Place.fromJson(await _api.post('Places', body: request.toJson()) as Map<String, dynamic>);

  Future<Place> update(int id, PlaceUpsertRequest request) async =>
      Place.fromJson(await _api.put('Places/$id', body: request.toJson()) as Map<String, dynamic>);

  Future<void> delete(int id) async {
    await _api.delete('Places/$id');
  }

  Future<void> uploadImage(int placeId, Uint8List bytes, String fileName, String contentType) async {
    await _api.postFile('Places/$placeId/images',
        field: 'file', bytes: bytes, fileName: fileName, contentType: contentType);
  }

  Future<void> setCoverImage(int imageId) async {
    await _api.put('Places/images/$imageId/cover');
  }

  Future<void> deleteImage(int imageId) async {
    await _api.delete('Places/images/$imageId');
  }

  String imageUrl(int imageId) => _api.url('Places/images/$imageId');
}
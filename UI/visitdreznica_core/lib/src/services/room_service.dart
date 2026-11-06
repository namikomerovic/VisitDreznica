import 'dart:typed_data';

import '../api/api_client.dart';
import '../models/page_result.dart';
import '../models/room.dart';

class RoomService {
  RoomService(this._api);

  final ApiClient _api;

  Future<PageResult<Room>> getPage(RoomSearch search, {int page = 1, int pageSize = 20}) async {
    final json = await _api.get('Rooms', query: search.toQuery(page: page, pageSize: pageSize));
    return PageResult.fromJson(json, Room.fromJson);
  }

  Future<Room> getById(int id) async => Room.fromJson(await _api.get('Rooms/$id') as Map<String, dynamic>);

  Future<Room> insert(RoomUpsertRequest request) async =>
      Room.fromJson(await _api.post('Rooms', body: request.toJson()) as Map<String, dynamic>);

  Future<Room> update(int id, RoomUpsertRequest request) async =>
      Room.fromJson(await _api.put('Rooms/$id', body: request.toJson()) as Map<String, dynamic>);

  Future<void> delete(int id) async {
    await _api.delete('Rooms/$id');
  }

  Future<void> uploadImage(int roomId, Uint8List bytes, String fileName, String contentType) async {
    await _api.postFile('Rooms/$roomId/images',
        field: 'file', bytes: bytes, fileName: fileName, contentType: contentType);
  }

  Future<void> setCoverImage(int imageId) async {
    await _api.put('Rooms/images/$imageId/cover');
  }

  Future<void> deleteImage(int imageId) async {
    await _api.delete('Rooms/images/$imageId');
  }

  String imageUrl(int imageId) => _api.url('Rooms/images/$imageId');
}
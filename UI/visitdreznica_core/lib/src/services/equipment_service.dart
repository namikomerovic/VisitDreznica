import 'dart:typed_data';

import '../api/api_client.dart';
import '../models/equipment.dart';
import '../models/page_result.dart';

class EquipmentService {
  EquipmentService(this._api);

  final ApiClient _api;

  Future<PageResult<Equipment>> getPage(EquipmentSearch search, {int page = 1, int pageSize = 20}) async {
    final json = await _api.get('Equipment', query: search.toQuery(page: page, pageSize: pageSize));
    return PageResult.fromJson(json, Equipment.fromJson);
  }

  Future<Equipment> getById(int id) async =>
      Equipment.fromJson(await _api.get('Equipment/$id') as Map<String, dynamic>);

  Future<Equipment> insert(EquipmentUpsertRequest request) async =>
      Equipment.fromJson(await _api.post('Equipment', body: request.toJson()) as Map<String, dynamic>);

  Future<Equipment> update(int id, EquipmentUpsertRequest request) async =>
      Equipment.fromJson(await _api.put('Equipment/$id', body: request.toJson()) as Map<String, dynamic>);

  Future<void> delete(int id) async {
    await _api.delete('Equipment/$id');
  }

  Future<void> setImage(int id, Uint8List bytes, String fileName, String contentType) async {
    await _api.putFile('Equipment/$id/image',
        field: 'file', bytes: bytes, fileName: fileName, contentType: contentType);
  }

  Future<void> deleteImage(int id) async {
    await _api.delete('Equipment/$id/image');
  }

  String imageUrl(int id) => _api.url('Equipment/$id/image');
}
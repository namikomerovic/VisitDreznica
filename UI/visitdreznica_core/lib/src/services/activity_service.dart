import 'dart:typed_data';

import '../api/api_client.dart';
import '../models/activity.dart';
import '../models/page_result.dart';

class ActivityService {
  ActivityService(this._api);

  final ApiClient _api;

  Future<PageResult<Activity>> getPage(ActivitySearch search, {int page = 1, int pageSize = 20}) async {
    final json = await _api.get('Activities', query: search.toQuery(page: page, pageSize: pageSize));
    return PageResult.fromJson(json, Activity.fromJson);
  }

  Future<Activity> getById(int id) async =>
      Activity.fromJson(await _api.get('Activities/$id') as Map<String, dynamic>);

  Future<Activity> insert(ActivityUpsertRequest request) async =>
      Activity.fromJson(await _api.post('Activities', body: request.toJson()) as Map<String, dynamic>);

  Future<Activity> update(int id, ActivityUpsertRequest request) async =>
      Activity.fromJson(await _api.put('Activities/$id', body: request.toJson()) as Map<String, dynamic>);

  Future<void> delete(int id) async {
    await _api.delete('Activities/$id');
  }

  Future<void> setImage(int id, Uint8List bytes, String fileName, String contentType) async {
    await _api.putFile('Activities/$id/image',
        field: 'file', bytes: bytes, fileName: fileName, contentType: contentType);
  }

  Future<void> deleteImage(int id) async {
    await _api.delete('Activities/$id/image');
  }

  String imageUrl(int id) => _api.url('Activities/$id/image');

  Future<PageResult<ActivitySlot>> getSlots({
    required int activityId,
    bool onlyUpcoming = true,
    int page = 1,
    int pageSize = 20,
  }) async {
    final json = await _api.get('ActivitySlots', query: {
      'activityId': activityId,
      'onlyUpcoming': onlyUpcoming,
      'page': page,
      'pageSize': pageSize,
    });
    return PageResult.fromJson(json, ActivitySlot.fromJson);
  }

  Future<void> insertSlot(int activityId, ActivitySlotRequest request) async {
    await _api.post('ActivitySlots', body: {'activityId': activityId, ...request.toJson()});
  }

  Future<void> updateSlot(int slotId, ActivitySlotRequest request) async {
    await _api.put('ActivitySlots/$slotId', body: request.toJson());
  }

  Future<void> deleteSlot(int slotId) async {
    await _api.delete('ActivitySlots/$slotId');
  }
}
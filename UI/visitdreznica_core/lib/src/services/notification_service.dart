import '../api/api_client.dart';
import '../models/notification.dart';
import '../models/page_result.dart';

class NotificationService {
  NotificationService(this._api);

  final ApiClient _api;

  Future<PageResult<AppNotification>> getPage({int page = 1, int pageSize = 20, bool onlyUnread = false}) async {
    final json = await _api.get('Notifications', query: {
      'page': page,
      'pageSize': pageSize,
      'onlyUnread': onlyUnread,
    });

    return PageResult.fromJson(json, AppNotification.fromJson);
  }

  Future<void> markAsRead(int id) async {
    await _api.post('Notifications/$id/read');
  }

  Future<void> markAllAsRead() async {
    await _api.post('Notifications/read-all');
  }

  Future<void> delete(int id) async {
    await _api.delete('Notifications/$id');
  }
}
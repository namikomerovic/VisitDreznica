import 'dart:async';

import 'package:flutter/foundation.dart';

import '../api/api_client.dart';

class NotificationProvider extends ChangeNotifier {
  NotificationProvider(this._api);

  static const _pollInterval = Duration(seconds: 30);

  final ApiClient _api;
  Timer? _timer;
  int _unreadCount = 0;

  int get unreadCount => _unreadCount;

  void start() {
    _timer?.cancel();
    refresh();
    _timer = Timer.periodic(_pollInterval, (_) => refresh());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _unreadCount = 0;
  }

  Future<void> refresh() async {
    if (!_api.hasToken) {
      return;
    }

    try {
      final json = await _api.get('Notifications/unread-count') as Map<String, dynamic>;
      final count = (json['count'] as num).toInt();

      if (count != _unreadCount) {
        _unreadCount = count;
        notifyListeners();
      }
    } catch (_) {
      // Zvonce ne smije srušiti aplikaciju; sljedeći pokušaj je za 30 sekundi.
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
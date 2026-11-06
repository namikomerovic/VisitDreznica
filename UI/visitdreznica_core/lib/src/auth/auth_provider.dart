import 'package:flutter/foundation.dart';

import '../api/api_client.dart';
import '../api/api_exception.dart';
import '../models/login_response.dart';
import 'app_roles.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._api, {required this.requiredRole}) {
    _api.onUnauthorized = _expire;
  }

  final ApiClient _api;
  final String requiredRole;

  LoginResponse? _session;
  String? _sessionMessage;

  LoginResponse? get session => _session;

  bool get isLoggedIn => _session != null;

  String? get sessionMessage => _sessionMessage;

  Future<void> login(String username, String password) async {
    final json = await _api.post('Auth/login', body: {
      'username': username.trim(),
      'password': password,
    });

    final response = LoginResponse.fromJson(json as Map<String, dynamic>);
    _api.token = response.token;

    if (!response.roles.contains(requiredRole)) {
      await _revokeQuietly();
      _api.token = null;

      throw ApiException(requiredRole == AppRoles.admin
          ? 'Ova aplikacija je namijenjena administratorima.'
          : 'Ova aplikacija je namijenjena gostima.');
    }

    _session = response;
    _sessionMessage = null;
    notifyListeners();
  }

  Future<void> logout() async {
    await _revokeQuietly();
    _clear();
  }

  void _expire() => _clear(message: 'Sesija je istekla. Prijavite se ponovo.');

  void _clear({String? message}) {
    _api.token = null;
    _session = null;
    _sessionMessage = message;
    notifyListeners();
  }

  Future<void> _revokeQuietly() async {
    try {
      await _api.post('Auth/logout');
    } catch (_) {
      // Sesija se na klijentu briše i ako server nije dostupan.
    }
  }
}
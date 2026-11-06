import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'api_exception.dart';

class ApiClient {
  ApiClient({required String baseUrl, http.Client? httpClient})
      : _baseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl,
        _http = httpClient ?? http.Client();

  static const _timeout = Duration(seconds: 20);

  final String _baseUrl;
  final http.Client _http;
  String? _token;

  void Function()? onUnauthorized;

  String get baseUrl => _baseUrl;

  set token(String? value) => _token = value;

  bool get hasToken => _token != null;

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) => _send('GET', path, query: query);

  Future<dynamic> post(String path, {Object? body, Map<String, dynamic>? query}) =>
      _send('POST', path, body: body ?? const {}, query: query);

  Future<dynamic> put(String path, {Object? body}) => _send('PUT', path, body: body ?? const {});

  Future<dynamic> delete(String path, {Map<String, dynamic>? query}) => _send('DELETE', path, query: query);

  Future<Uint8List> getBytes(String path, {Map<String, dynamic>? query}) async {
    final response = await _execute('GET', path, query: query);
    _ensureSuccess(response);
    return response.bodyBytes;
  }

  Future<dynamic> _send(String method, String path, {Object? body, Map<String, dynamic>? query}) async {
    final response = await _execute(method, path, body: body, query: query);
    _ensureSuccess(response);

    if (response.bodyBytes.isEmpty) {
      return null;
    }

    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  Future<http.Response> _execute(String method, String path, {Object? body, Map<String, dynamic>? query}) async {
    final request = http.Request(method, _uri(path, query));
    request.headers['Accept'] = 'application/json';

    if (_token != null) {
      request.headers['Authorization'] = 'Bearer $_token';
    }

    if (body != null) {
      request.headers['Content-Type'] = 'application/json; charset=utf-8';
      request.body = jsonEncode(body);
    }

    try {
      final streamed = await _http.send(request).timeout(_timeout);
      return await http.Response.fromStream(streamed).timeout(_timeout);
    } on TimeoutException {
      throw ApiException('Server ne odgovara. Pokušajte ponovo.');
    } on http.ClientException {
      throw ApiException('Nije moguće povezati se sa serverom. Provjerite da li je API pokrenut.');
    }
  }

  Uri _uri(String path, Map<String, dynamic>? query) {
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    final parameters = <String, dynamic>{};

    query?.forEach((key, value) {
      if (value == null) return;
      parameters[key] = value is Iterable ? value.map((x) => x.toString()).toList() : value.toString();
    });

    return Uri.parse('$_baseUrl/$cleanPath').replace(queryParameters: parameters.isEmpty ? null : parameters);
  }

  void _ensureSuccess(http.Response response) {
    final status = response.statusCode;

    if (status >= 200 && status < 300) {
      return;
    }

    final problem = _readProblem(response);

    if (status == 401) {
      if (_token != null) {
        onUnauthorized?.call();
      }
      throw ApiException(problem.message ?? 'Sesija je istekla. Prijavite se ponovo.', statusCode: status);
    }

    final fallback = switch (status) {
      400 => 'Podaci nisu ispravni.',
      403 => 'Nemate pravo na ovu akciju.',
      404 => 'Traženi podatak ne postoji.',
      409 => 'Podatak je u međuvremenu izmijenjen. Osvježite prikaz.',
      _ => 'Došlo je do greške na serveru. Pokušajte ponovo.'
    };

    throw ApiException(problem.message ?? fallback, statusCode: status, fieldErrors: problem.fieldErrors);
  }

  ({String? message, Map<String, List<String>> fieldErrors}) _readProblem(http.Response response) {
    try {
      final json = jsonDecode(utf8.decode(response.bodyBytes));

      if (json is! Map<String, dynamic>) {
        return (message: null, fieldErrors: const {});
      }

      final fieldErrors = <String, List<String>>{};
      final errors = json['errors'];

      if (errors is Map<String, dynamic>) {
        errors.forEach((key, value) {
          if (value is List) {
            fieldErrors[key] = value.map((x) => x.toString()).toList();
          }
        });
      }

      final message = fieldErrors.isNotEmpty
          ? fieldErrors.values.expand((x) => x).join('\n')
          : (json['detail'] as String?) ?? (json['title'] as String?);

      return (message: message, fieldErrors: fieldErrors);
    } catch (_) {
      return (message: null, fieldErrors: const {});
    }
  }
}
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'api_exception.dart';

class ApiClient {
  ApiClient({required String baseUrl, http.Client? httpClient})
      : _baseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl,
        _http = httpClient ?? http.Client();

  static const _timeout = Duration(seconds: 30);

  final String _baseUrl;
  final http.Client _http;
  String? _token;

  void Function()? onUnauthorized;

  String get baseUrl => _baseUrl;

  set token(String? value) => _token = value;

  bool get hasToken => _token != null;

  Map<String, String> get authHeaders => _token == null ? const {} : {'Authorization': 'Bearer $_token'};

  String url(String path) => _uri(path, null).toString();

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) =>
      _sendJson('GET', path, query: query);

  Future<dynamic> post(String path, {Object? body, Map<String, dynamic>? query}) =>
      _sendJson('POST', path, body: body ?? const {}, query: query);

  Future<dynamic> put(String path, {Object? body}) => _sendJson('PUT', path, body: body ?? const {});

  Future<dynamic> delete(String path, {Map<String, dynamic>? query}) => _sendJson('DELETE', path, query: query);

  Future<Uint8List> getBytes(String path, {Map<String, dynamic>? query}) async {
    final request = http.Request('GET', _uri(path, query))..headers.addAll(_headers());
    final response = await _dispatch(request);
    _ensureSuccess(response);
    return response.bodyBytes;
  }

  Future<dynamic> postFile(
    String path, {
    required String field,
    required Uint8List bytes,
    required String fileName,
    required String contentType,
  }) async {
    final request = http.MultipartRequest('POST', _uri(path, null))
      ..headers.addAll(_headers())
      ..files.add(http.MultipartFile.fromBytes(
        field,
        bytes,
        filename: fileName,
        contentType: MediaType.parse(contentType),
      ));

    return _decode(await _dispatch(request));
  }

  Future<dynamic> _sendJson(String method, String path, {Object? body, Map<String, dynamic>? query}) async {
    final request = http.Request(method, _uri(path, query))..headers.addAll(_headers());

    if (body != null) {
      request.headers['Content-Type'] = 'application/json; charset=utf-8';
      request.body = jsonEncode(body);
    }

    return _decode(await _dispatch(request));
  }

  Map<String, String> _headers() => {'Accept': 'application/json', ...authHeaders};

  Future<http.Response> _dispatch(http.BaseRequest request) async {
    try {
      final streamed = await _http.send(request).timeout(_timeout);
      return await http.Response.fromStream(streamed).timeout(_timeout);
    } on TimeoutException {
      throw ApiException('Server ne odgovara. Pokušajte ponovo.');
    } on http.ClientException {
      throw ApiException('Nije moguće povezati se sa serverom. Provjerite da li je API pokrenut.');
    }
  }

  dynamic _decode(http.Response response) {
    _ensureSuccess(response);

    if (response.bodyBytes.isEmpty) {
      return null;
    }

    return jsonDecode(utf8.decode(response.bodyBytes));
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
      413 => 'Fajl je prevelik.',
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
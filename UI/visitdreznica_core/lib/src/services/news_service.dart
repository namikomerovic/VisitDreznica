import 'dart:typed_data';

import '../api/api_client.dart';
import '../models/news.dart';
import '../models/page_result.dart';

class NewsService {
  NewsService(this._api);

  final ApiClient _api;

  Future<PageResult<NewsItem>> getPage({String? title, int page = 1, int pageSize = 20}) async {
    final trimmed = title?.trim();
    final json = await _api.get('News', query: {
      'page': page,
      'pageSize': pageSize,
      if (trimmed != null && trimmed.isNotEmpty) 'title': trimmed,
    });
    return PageResult.fromJson(json, NewsItem.fromJson);
  }

  Future<NewsItem> getById(int id) async => NewsItem.fromJson(await _api.get('News/$id') as Map<String, dynamic>);

  Future<NewsItem> insert(NewsUpsertRequest request) async =>
      NewsItem.fromJson(await _api.post('News', body: request.toJson()) as Map<String, dynamic>);

  Future<NewsItem> update(int id, NewsUpsertRequest request) async =>
      NewsItem.fromJson(await _api.put('News/$id', body: request.toJson()) as Map<String, dynamic>);

  Future<void> delete(int id) async {
    await _api.delete('News/$id');
  }

  Future<void> setImage(int id, Uint8List bytes, String fileName, String contentType) async {
    await _api.putFile('News/$id/image', field: 'file', bytes: bytes, fileName: fileName, contentType: contentType);
  }

  Future<void> deleteImage(int id) async {
    await _api.delete('News/$id/image');
  }

  String imageUrl(int id) => _api.url('News/$id/image');
}
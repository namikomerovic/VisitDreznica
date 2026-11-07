import '../api/api_client.dart';
import '../models/page_result.dart';
import '../models/review.dart';

class ReviewService {
  ReviewService(this._api);

  final ApiClient _api;

  Future<PageResult<Review>> getPage({
    ItemType? itemType,
    int? minRating,
    int? maxRating,
    int page = 1,
    int pageSize = 20,
  }) async {
    final json = await _api.get('Reviews', query: {
      'page': page,
      'pageSize': pageSize,
      if (itemType != null) 'itemType': itemType.value,
      if (minRating != null) 'minRating': minRating,
      if (maxRating != null) 'maxRating': maxRating,
    });
    return PageResult.fromJson(json, Review.fromJson);
  }

  Future<void> delete(int id) async {
    await _api.delete('Reviews/$id');
  }
}
import '../api/api_client.dart';
import '../models/page_result.dart';
import '../models/review.dart';
import '../models/recommendation.dart';


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

    Future<Map<int, ReviewSummaryItem>> getSummaries(ItemType itemType) async {
    final json = await _api.get('Reviews/summaries', query: {'itemType': itemType.value}) as List<dynamic>;
    final items = json.map((x) => ReviewSummaryItem.fromJson(x as Map<String, dynamic>));
    return {for (final item in items) item.itemId: item};
  }
}
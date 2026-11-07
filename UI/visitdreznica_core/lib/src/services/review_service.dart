import '../api/api_client.dart';
import '../models/page_result.dart';
import '../models/recommendation.dart';
import '../models/review.dart';

class ReviewService {
  ReviewService(this._api);

  final ApiClient _api;

  Future<PageResult<Review>> getPage({
    ItemType? itemType,
    int? itemId,
    int? minRating,
    int? maxRating,
    int page = 1,
    int pageSize = 20,
  }) async {
    final json = await _api.get('Reviews', query: {
      'page': page,
      'pageSize': pageSize,
      if (itemType != null) 'itemType': itemType.value,
      'itemId': itemId,
      'minRating': minRating,
      'maxRating': maxRating,
    });
    return PageResult.fromJson(json, Review.fromJson);
  }

  Future<ReviewSummary> getSummary(ItemType itemType, int itemId) async => ReviewSummary.fromJson(
        await _api.get('Reviews/summary', query: {'itemType': itemType.value, 'itemId': itemId})
            as Map<String, dynamic>,
      );

  Future<Map<int, ReviewSummaryItem>> getSummaries(ItemType itemType) async {
    final json = await _api.get('Reviews/summaries', query: {'itemType': itemType.value}) as List<dynamic>;
    final items = json.map((x) => ReviewSummaryItem.fromJson(x as Map<String, dynamic>));
    return {for (final item in items) item.itemId: item};
  }

  Future<Review> create(ItemType itemType, int itemId, {required int rating, String? comment}) async =>
      Review.fromJson(await _api.post('Reviews', body: {
        'itemType': itemType.value,
        'itemId': itemId,
        'rating': rating,
        'comment': comment,
      }) as Map<String, dynamic>);

  Future<Review> update(int id, {required int rating, String? comment}) async =>
      Review.fromJson(await _api.put('Reviews/$id', body: {
        'rating': rating,
        'comment': comment,
      }) as Map<String, dynamic>);

  Future<void> delete(int id) async {
    await _api.delete('Reviews/$id');
  }
}
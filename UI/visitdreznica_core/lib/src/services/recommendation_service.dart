import '../api/api_client.dart';
import '../models/recommender_model.dart';
import '../models/item_type.dart';
import '../models/recommendation.dart';

class RecommendationService {
  RecommendationService(this._api);

  final ApiClient _api;

  Future<RecommenderModelInfo> getModel() async =>
      RecommenderModelInfo.fromJson(await _api.get('Recommendations/model') as Map<String, dynamic>);

  Future<RecommenderModelInfo> train() async =>
      RecommenderModelInfo.fromJson(await _api.post('Recommendations/train') as Map<String, dynamic>);

    Future<List<Recommendation>> getForMe({ItemType? itemType, int take = 10}) async {
    final json = await _api.get('Recommendations', query: {
      'take': take,
      if (itemType != null) 'itemType': itemType.value,
    }) as List<dynamic>;

    return json.map((x) => Recommendation.fromJson(x as Map<String, dynamic>)).toList();
  }
}
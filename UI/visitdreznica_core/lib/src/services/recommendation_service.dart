import '../api/api_client.dart';
import '../models/recommender_model.dart';

class RecommendationService {
  RecommendationService(this._api);

  final ApiClient _api;

  Future<RecommenderModelInfo> getModel() async =>
      RecommenderModelInfo.fromJson(await _api.get('Recommendations/model') as Map<String, dynamic>);

  Future<RecommenderModelInfo> train() async =>
      RecommenderModelInfo.fromJson(await _api.post('Recommendations/train') as Map<String, dynamic>);
}
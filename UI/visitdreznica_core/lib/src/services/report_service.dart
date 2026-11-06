import '../api/api_client.dart';
import '../models/dashboard.dart';

class ReportService {
  ReportService(this._api);

  final ApiClient _api;

  Future<DashboardResponse> getDashboard() async {
    final json = await _api.get('Reports/dashboard');
    return DashboardResponse.fromJson(json as Map<String, dynamic>);
  }
}
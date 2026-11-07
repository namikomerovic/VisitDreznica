import 'dart:typed_data';

import '../api/api_client.dart';
import '../models/dashboard.dart';

enum ReportKind {
  financial('financial', 'finansijski-izvjestaj'),
  occupancy('occupancy', 'zauzetost-smjestaja'),
  activities('activities', 'aktivnosti-i-ocjene');

  const ReportKind(this.path, this.filePrefix);

  final String path;
  final String filePrefix;
}

class ReportService {
  ReportService(this._api);

  final ApiClient _api;

  Future<DashboardResponse> getDashboard() async {
    final json = await _api.get('Reports/dashboard');
    return DashboardResponse.fromJson(json as Map<String, dynamic>);
  }

  Future<Uint8List> downloadPdf(ReportKind kind, DateTime from, DateTime to) =>
      _api.getBytes('Reports/${kind.path}/pdf', query: {'from': _date(from), 'to': _date(to)});

  static String _date(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}
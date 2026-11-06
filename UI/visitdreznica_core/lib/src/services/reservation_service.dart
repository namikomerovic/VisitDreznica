import '../api/api_client.dart';
import '../models/page_result.dart';
import '../models/reservation.dart';

class ReservationService {
  ReservationService(this._api);

  final ApiClient _api;

  Future<PageResult<Reservation>> getPage(ReservationSearch search, {int page = 1, int pageSize = 20}) async {
    final json = await _api.get('Reservations', query: search.toQuery(page: page, pageSize: pageSize));
    return PageResult.fromJson(json, Reservation.fromJson);
  }

  Future<Reservation> getById(int id) async {
    final json = await _api.get('Reservations/$id');
    return Reservation.fromJson(json as Map<String, dynamic>);
  }

  Future<Reservation> confirm(int id, {String? comment}) => _changeStatus(id, 'confirm', comment);

  Future<Reservation> reject(int id, {required String comment}) => _changeStatus(id, 'reject', comment);

  Future<Reservation> complete(int id, {String? comment}) => _changeStatus(id, 'complete', comment);

  Future<Reservation> cancel(int id, {required String comment}) => _changeStatus(id, 'cancel', comment);

  Future<Reservation> _changeStatus(int id, String action, String? comment) async {
    final json = await _api.post('Reservations/$id/$action', body: {'comment': comment});
    return Reservation.fromJson(json as Map<String, dynamic>);
  }
}
import '../api/api_client.dart';
import '../models/booking.dart';
import '../models/reservation.dart';

class BookingService {
  BookingService(this._api);

  final ApiClient _api;

  static String _date(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';

  static String _instant(DateTime value) => value.toUtc().toIso8601String();

  Future<RoomQuote> quoteRoom({
    required int roomId,
    required DateTime checkIn,
    required DateTime checkOut,
    required int guestCount,
  }) async =>
      RoomQuote.fromJson(await _api.get('RoomReservations/quote', query: {
        'roomId': roomId,
        'checkIn': _date(checkIn),
        'checkOut': _date(checkOut),
        'guestCount': guestCount,
      }) as Map<String, dynamic>);

  Future<List<OccupiedPeriod>> roomOccupancy(int roomId, DateTime from, DateTime to) async {
    final json = await _api.get('RoomReservations/occupancy', query: {
      'roomId': roomId,
      'from': _date(from),
      'to': _date(to),
    }) as List<dynamic>;

    return json.map((x) => OccupiedPeriod.fromJson(x as Map<String, dynamic>)).toList();
  }

  Future<Reservation> bookRoom({
    required int roomId,
    required DateTime checkIn,
    required DateTime checkOut,
    required int guestCount,
    String? note,
  }) async =>
      Reservation.fromJson(await _api.post('RoomReservations', body: {
        'roomId': roomId,
        'checkIn': _date(checkIn),
        'checkOut': _date(checkOut),
        'guestCount': guestCount,
        'note': _clean(note),
      }) as Map<String, dynamic>);

  Future<EquipmentQuote> quoteEquipment({
    required int equipmentId,
    required DateTime start,
    required DateTime end,
    required int quantity,
  }) async =>
      EquipmentQuote.fromJson(await _api.get('EquipmentReservations/quote', query: {
        'equipmentId': equipmentId,
        'startTime': _instant(start),
        'endTime': _instant(end),
        'quantity': quantity,
      }) as Map<String, dynamic>);

  Future<Reservation> bookEquipment({
    required int equipmentId,
    required DateTime start,
    required DateTime end,
    required int quantity,
    String? note,
  }) async =>
      Reservation.fromJson(await _api.post('EquipmentReservations', body: {
        'equipmentId': equipmentId,
        'startTime': _instant(start),
        'endTime': _instant(end),
        'quantity': quantity,
        'note': _clean(note),
      }) as Map<String, dynamic>);

  Future<Reservation> bookActivity({
    required int activitySlotId,
    required int participantCount,
    String? note,
  }) async =>
      Reservation.fromJson(await _api.post('ActivityReservations', body: {
        'activitySlotId': activitySlotId,
        'participantCount': participantCount,
        'note': _clean(note),
      }) as Map<String, dynamic>);

  static String? _clean(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
import '../api/api_client.dart';
import '../models/booking.dart';

class PaymentService {
  PaymentService(this._api);

  final ApiClient _api;

  Future<PaymentIntentInfo> createIntent(int reservationId) async => PaymentIntentInfo.fromJson(
        await _api.post('Payments/intent', body: {'reservationId': reservationId}) as Map<String, dynamic>,
      );

  Future<void> confirm(String paymentIntentId) async {
    await _api.post('Payments/confirm', body: {'paymentIntentId': paymentIntentId});
  }
}
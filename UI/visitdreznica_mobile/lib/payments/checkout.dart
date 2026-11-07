import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart'
    show FailureCode, SetupPaymentSheetParameters, Stripe, StripeException;
import 'package:visitdreznica_core/visitdreznica_core.dart';

enum CheckoutResult { paid, cancelled }

class PaymentFailure implements Exception {
  PaymentFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

class Checkout {
  Checkout(ApiClient api) : _payments = PaymentService(api);

  final PaymentService _payments;

  Future<CheckoutResult> pay(int reservationId) async {
    try {
      final intent = await _payments.createIntent(reservationId);

      Stripe.publishableKey = intent.publishableKey;
      await Stripe.instance.applySettings();

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: intent.clientSecret,
          merchantDisplayName: 'Visit Drežnica',
          style: ThemeMode.light,
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      await _payments.confirm(intent.paymentIntentId);

      return CheckoutResult.paid;
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        return CheckoutResult.cancelled;
      }
      throw PaymentFailure(e.error.localizedMessage ?? 'Plaćanje nije uspjelo. Pokušajte ponovo.');
    } on ApiException catch (e) {
      throw PaymentFailure(e.message);
    }
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../payments/checkout.dart';
import 'booking_result_screen.dart';

Future<void> submitBooking(BuildContext context, Future<Reservation> Function() create) async {
  final api = context.read<ApiClient>();
  final navigator = Navigator.of(context);
  final messenger = ScaffoldMessenger.of(context);

  final Reservation reservation;

  try {
    reservation = await create();
  } on ApiException catch (e) {
    messenger.showSnackBar(SnackBar(content: Text(e.message)));
    return;
  }

  CheckoutResult result;
  String? error;

  try {
    result = await Checkout(api).pay(reservation.id);
  } on PaymentFailure catch (e) {
    result = CheckoutResult.cancelled;
    error = e.message;
  }

  if (!navigator.mounted) return;

  await navigator.pushReplacement(MaterialPageRoute<void>(
    builder: (_) => BookingResultScreen(reservation: reservation, initialResult: result, initialError: error),
  ));
}
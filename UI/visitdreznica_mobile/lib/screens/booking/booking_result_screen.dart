import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../payments/checkout.dart';
import '../../widgets/message_box.dart';

class BookingResultScreen extends StatefulWidget {
  const BookingResultScreen({
    super.key,
    required this.reservation,
    required this.initialResult,
    this.initialError,
  });

  final Reservation reservation;
  final CheckoutResult initialResult;
  final String? initialError;

  @override
  State<BookingResultScreen> createState() => _BookingResultScreenState();
}

class _BookingResultScreenState extends State<BookingResultScreen> {
  late CheckoutResult _result = widget.initialResult;
  late String? _error = widget.initialError;
  bool _paying = false;

  Future<void> _payAgain() async {
    final checkout = Checkout(context.read<ApiClient>());
    setState(() {
      _paying = true;
      _error = null;
    });

    try {
      final result = await checkout.pay(widget.reservation.id);
      if (mounted) setState(() => _result = result);
    } on PaymentFailure catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _paying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reservation = widget.reservation;
    final paid = _result == CheckoutResult.paid;

    return Scaffold(
      appBar: AppBar(title: const Text('Rezervacija')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 16),
          Icon(
            paid ? Icons.check_circle : Icons.schedule,
            size: 80,
            color: paid ? AppColors.success : AppColors.warning,
          ),
          const SizedBox(height: 16),
          Text(
            paid ? 'Plaćanje je uspjelo!' : 'Rezervacija čeka plaćanje',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            paid
                ? 'Rezervacija je plaćena i čeka potvrdu. Obavijest i e-mail stižu čim je potvrdimo.'
                : 'Rezervacija je sačuvana, ali nije plaćena. Ako je ne platite u roku od 30 minuta, automatski se otkazuje.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (_error != null) MessageBox(text: _error!, isError: true),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(reservation.itemName, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(reservation.type.label, style: theme.textTheme.bodySmall),
                  const Divider(height: 24),
                  _row('Termin', reservation.periodLabel),
                  _row(reservation.quantityLabel.split(':').first, reservation.quantityLabel.split(':').last.trim()),
                  _row('Broj rezervacije', '#${reservation.id}'),
                  _row('Iznos', Formatters.money(reservation.totalPrice)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (!paid)
            FilledButton.icon(
              onPressed: _paying ? null : _payAgain,
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
              icon: _paying
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.credit_card),
              label: const Text('Plati sada'),
            ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: _paying ? null : () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
            child: const Text('Gotovo'),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 130, child: Text(label)),
            Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600))),
          ],
        ),
      );
}
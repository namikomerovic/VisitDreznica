import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../payments/checkout.dart';
import '../../utils/item_type_ui.dart';
import '../../utils/reservation_status_ui.dart';
import '../../widgets/message_box.dart';
import '../../widgets/status_chip.dart';
import '../details/item_navigation.dart';
import '../details/review_sheet.dart';

class ReservationDetailsScreen extends StatefulWidget {
  const ReservationDetailsScreen({super.key, required this.reservationId});

  final int reservationId;

  @override
  State<ReservationDetailsScreen> createState() => _ReservationDetailsScreenState();
}

class _ReservationDetailsScreenState extends State<ReservationDetailsScreen> {
  static const _paymentWindow = Duration(minutes: 30);

  late final ReservationService _service;
  late final ReviewService _reviews;

  Reservation? _reservation;
  ReviewSummary? _review;
  String? _error;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final api = context.read<ApiClient>();
    _service = ReservationService(api);
    _reviews = ReviewService(api);
    _load();
  }

  Future<void> _load() async {
    try {
      final reservation = await _service.getById(widget.reservationId);
      ReviewSummary? review;

      if (reservation.status == ReservationStatus.completed && reservation.itemId != null) {
        review = await _reviews.getSummary(reservation.itemType, reservation.itemId!);
      }

      if (!mounted) return;
      setState(() {
        _reservation = reservation;
        _review = review;
        _error = null;
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  void _showMessage(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  Future<void> _pay() async {
    final checkout = Checkout(context.read<ApiClient>());
    setState(() => _busy = true);

    try {
      final result = await checkout.pay(widget.reservationId);
      if (mounted && result == CheckoutResult.paid) _showMessage('Plaćanje je uspjelo.');
    } on PaymentFailure catch (e) {
      if (mounted) _showMessage(e.message);
    } finally {
      if (mounted) {
        setState(() => _busy = false);
        _load();
      }
    }
  }

  Future<void> _cancel(Reservation reservation) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (_) => _CancelDialog(isPaid: reservation.isPaid),
    );

    if (reason == null || !mounted) return;
    setState(() => _busy = true);

    try {
      await _service.cancel(reservation.id, comment: reason);
      if (!mounted) return;
      _showMessage(reservation.isPaid
          ? 'Rezervacija je otkazana. Novac se vraća na vašu karticu.'
          : 'Rezervacija je otkazana.');
      await _load();
    } on ApiException catch (e) {
      if (mounted) _showMessage(e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _writeReview(Reservation reservation) async {
    final saved = await showReviewSheet(
      context,
      type: reservation.itemType,
      itemId: reservation.itemId!,
      existing: _review?.myReview,
    );

    if (saved && mounted) {
      _showMessage('Hvala na recenziji!');
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final reservation = _reservation;

    return Scaffold(
      appBar: AppBar(title: Text('Rezervacija #${widget.reservationId}')),
      body: reservation == null
          ? Center(child: _error == null ? const CircularProgressIndicator() : Text(_error!))
          : RefreshIndicator(onRefresh: _load, child: _buildContent(reservation)),
    );
  }

  Widget _buildContent(Reservation reservation) {
    final theme = Theme.of(context);
    final itemType = reservation.itemType;
    final review = _review;
    final payUntil = reservation.createdAt.add(_paymentWindow);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          children: [
            Icon(itemType.icon, color: itemType.color, size: 18),
            const SizedBox(width: 6),
            Text(reservation.type.label, style: theme.textTheme.labelLarge?.copyWith(color: itemType.color)),
          ],
        ),
        const SizedBox(height: 6),
        Text(reservation.itemName, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        Align(alignment: Alignment.centerLeft, child: StatusChip(status: reservation.status)),
        const SizedBox(height: 16),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _InfoRow('Termin', reservation.periodLabel),
                _InfoRow(reservation.quantityLabel.split(':').first, reservation.quantityLabel.split(':').last.trim()),
                _InfoRow('Iznos', Formatters.money(reservation.totalPrice)),
                _InfoRow('Plaćanje', reservation.isPaid ? 'Plaćeno karticom' : 'Nije plaćeno'),
                _InfoRow('Kreirana', Formatters.dateTime(reservation.createdAt)),
                if (reservation.note != null && reservation.note!.isNotEmpty) _InfoRow('Napomena', reservation.note!),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (reservation.awaitsPayment) ...[
          MessageBox(
            text: 'Rezervaciju platite do ${Formatters.time(payUntil)}, inače se automatski otkazuje.',
          ),
          FilledButton.icon(
            onPressed: _busy ? null : _pay,
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
            icon: const Icon(Icons.credit_card),
            label: Text('Plati ${Formatters.money(reservation.totalPrice)}'),
          ),
          const SizedBox(height: 8),
        ],
        if (reservation.status == ReservationStatus.completed && review != null && reservation.itemId != null) ...[
          if (review.myReview != null)
            OutlinedButton.icon(
              onPressed: _busy ? null : () => _writeReview(reservation),
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
              icon: const Icon(Icons.edit_outlined),
              label: Text('Vaša ocjena: ${review.myReview!.rating}★ · uredi'),
            )
          else if (review.canReview)
            FilledButton.tonalIcon(
              onPressed: _busy ? null : () => _writeReview(reservation),
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
              icon: const Icon(Icons.star_outline_rounded),
              label: const Text('Ocijeni'),
            ),
          const SizedBox(height: 8),
        ],
        if (reservation.itemId != null)
          OutlinedButton.icon(
            onPressed: () => openItemDetails(context, itemType, reservation.itemId!),
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
            icon: Icon(itemType.icon),
            label: Text('Pogledaj: ${reservation.itemName}', overflow: TextOverflow.ellipsis),
          ),
        if (reservation.isActive) ...[
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: _busy ? null : () => _cancel(reservation),
            style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
            icon: const Icon(Icons.cancel_outlined),
            label: const Text('Otkaži rezervaciju'),
          ),
          if (reservation.status == ReservationStatus.confirmed)
            Text(
              'Potvrđenu rezervaciju možete otkazati najkasnije 24 sata prije početka. Uplaćeni iznos se vraća na karticu.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
        ],
        if (reservation.statusHistory.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text('Historija', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          for (final change in reservation.statusHistory)
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: Icon(change.toStatus.icon, color: change.toStatus.color),
              title: Text(change.toStatus.label),
              subtitle: Text([
                '${Formatters.dateTime(change.changedAt)} · ${change.changedByFullName}',
                if (change.comment != null && change.comment!.isNotEmpty) change.comment!,
              ].join('\n')),
            ),
        ],
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text(label)),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}

class _CancelDialog extends StatefulWidget {
  const _CancelDialog({required this.isPaid});

  final bool isPaid;

  @override
  State<_CancelDialog> createState() => _CancelDialogState();
}

class _CancelDialogState extends State<_CancelDialog> {
  final _reason = TextEditingController();

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Otkazati rezervaciju?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.isPaid
              ? 'Uplaćeni iznos biće vraćen na vašu karticu.'
              : 'Rezervacija još nije plaćena, pa nema povrata novca.'),
          const SizedBox(height: 12),
          TextField(
            controller: _reason,
            maxLength: 500,
            maxLines: 2,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Razlog (nije obavezan)',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Nazad')),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: theme.colorScheme.error),
          onPressed: () => Navigator.pop(context, _reason.text.trim()),
          child: const Text('Otkaži rezervaciju'),
        ),
      ],
    );
  }
}
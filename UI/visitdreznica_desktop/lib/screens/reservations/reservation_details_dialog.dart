import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../widgets/reservation_status_chip.dart';

Future<void> showReservationDetailsDialog(BuildContext context, int reservationId, {VoidCallback? onChanged}) {
  return showDialog<void>(
    context: context,
    builder: (_) => ReservationDetailsDialog(reservationId: reservationId, onChanged: onChanged),
  );
}

class ReservationDetailsDialog extends StatefulWidget {
  const ReservationDetailsDialog({super.key, required this.reservationId, this.onChanged});

  final int reservationId;
  final VoidCallback? onChanged;

  @override
  State<ReservationDetailsDialog> createState() => _ReservationDetailsDialogState();
}

class _ReservationDetailsDialogState extends State<ReservationDetailsDialog> {
  late final ReservationService _service;

  Reservation? _reservation;
  String? _loadError;
  String? _actionError;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _service = ReservationService(context.read<ApiClient>());
    _load();
  }

  Future<void> _load() async {
    try {
      final reservation = await _service.getById(widget.reservationId);
      if (mounted) setState(() => _reservation = reservation);
    } on ApiException catch (e) {
      if (mounted) setState(() => _loadError = e.message);
    }
  }

  Future<void> _perform(String successMessage, Future<Reservation> Function() action) async {
    setState(() {
      _busy = true;
      _actionError = null;
    });

    try {
      final updated = await action();
      if (!mounted) return;

      setState(() => _reservation = updated);
      widget.onChanged?.call();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(successMessage)));
    } on ApiException catch (e) {
      if (mounted) setState(() => _actionError = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<bool> _confirm(String title, String message) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Odustani')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Potvrdi')),
        ],
      ),
    );

    return result == true;
  }

  Future<String?> _askReason(String title, String hint) {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: 420,
          child: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              autofocus: true,
              maxLines: 3,
              maxLength: 500,
              decoration: InputDecoration(
                labelText: 'Razlog',
                hintText: hint,
                helperText: 'Gost će vidjeti razlog u obavijesti i emailu.',
                border: const OutlineInputBorder(),
              ),
              validator: (value) =>
                  (value == null || value.trim().length < 3) ? 'Unesite razlog (najmanje 3 znaka).' : null,
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Odustani')),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, controller.text.trim());
              }
            },
            child: const Text('Potvrdi'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReservation(Reservation r) async {
    if (!await _confirm('Potvrda rezervacije', 'Potvrditi rezervaciju #${r.id}? Gost će dobiti obavijest.')) return;
    await _perform('Rezervacija je potvrđena.', () => _service.confirm(r.id));
  }

  Future<void> _rejectReservation(Reservation r) async {
    final reason = await _askReason('Odbijanje rezervacije #${r.id}', 'npr. Soba nije dostupna zbog radova.');
    if (reason == null) return;
    await _perform('Rezervacija je odbijena.', () => _service.reject(r.id, comment: reason));
  }

  Future<void> _completeReservation(Reservation r) async {
    if (!await _confirm('Završetak rezervacije', 'Označiti rezervaciju #${r.id} kao završenu? '
        'Gost će dobiti poziv da ostavi recenziju.')) {
      return;
    }
    await _perform('Rezervacija je označena kao završena.', () => _service.complete(r.id));
  }

  Future<void> _cancelReservation(Reservation r) async {
    final reason = await _askReason('Otkazivanje rezervacije #${r.id}', 'npr. Loši vremenski uslovi.');
    if (reason == null) return;
    await _perform('Rezervacija je otkazana.', () => _service.cancel(r.id, comment: reason));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680, maxHeight: 760),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_loadError != null) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_loadError!),
            const SizedBox(height: 16),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Zatvori')),
          ],
        ),
      );
    }

    final r = _reservation;

    if (r == null) {
      return const SizedBox(height: 240, child: Center(child: CircularProgressIndicator()));
    }

    final theme = Theme.of(context);
    final refundNote = r.isPaid ? ' Uplaćeni iznos se automatski vraća gostu.' : '';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 8, 8),
          child: Row(
            children: [
              Text('Rezervacija #${r.id}', style: theme.textTheme.titleLarge),
              const SizedBox(width: 12),
              ReservationStatusChip(status: r.status),
              const Spacer(),
              IconButton(
                tooltip: 'Zatvori',
                onPressed: _busy ? null : () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow('Gost', r.userFullName),
                _InfoRow('Vrsta', r.type.label),
                _InfoRow('Stavka', r.itemName),
                _InfoRow('Termin', r.periodLabel),
                _InfoRow('Količina', r.quantityLabel),
                _InfoRow('Iznos', Formatters.money(r.totalPrice)),
                _InfoRow('Plaćanje', r.isPaid ? 'Plaćeno karticom' : 'Nije plaćeno'),
                _InfoRow('Kreirana', Formatters.dateTime(r.createdAt)),
                if (r.note != null && r.note!.trim().isNotEmpty) _InfoRow('Napomena gosta', r.note!),
                const SizedBox(height: 20),
                Text('Historija statusa', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                for (final change in r.statusHistory) _HistoryEntry(change: change),
              ],
            ),
          ),
        ),
        if (_actionError != null)
          Container(
            margin: const EdgeInsets.fromLTRB(24, 0, 24, 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(_actionError!, style: TextStyle(color: theme.colorScheme.onErrorContainer)),
          ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(16),
          child: _buildActions(r, refundNote),
        ),
      ],
    );
  }

  Widget _buildActions(Reservation r, String refundNote) {
    if (_busy) {
      return const Center(child: SizedBox(height: 36, child: CircularProgressIndicator()));
    }

    final actions = <Widget>[];

    if (r.status == ReservationStatus.pending) {
      actions.add(OutlinedButton.icon(
        onPressed: () => _rejectReservation(r),
        icon: const Icon(Icons.block),
        label: const Text('Odbij'),
      ));
      actions.add(Tooltip(
        message: r.isPaid ? '' : 'Gost još nije platio rezervaciju.',
        child: FilledButton.icon(
          onPressed: r.isPaid ? () => _confirmReservation(r) : null,
          icon: const Icon(Icons.check),
          label: const Text('Potvrdi'),
        ),
      ));
    }

    if (r.status == ReservationStatus.confirmed) {
      actions.add(OutlinedButton.icon(
        onPressed: () => _cancelReservation(r),
        icon: const Icon(Icons.event_busy),
        label: const Text('Otkaži'),
      ));
      actions.add(FilledButton.icon(
        onPressed: () => _completeReservation(r),
        icon: const Icon(Icons.task_alt),
        label: const Text('Označi kao završenu'),
      ));
    }

    if (actions.isEmpty) {
      return Text(
        'Za rezervaciju sa statusom "${r.status.label}" nema dostupnih akcija.',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (refundNote.isNotEmpty && r.status != ReservationStatus.completed)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Odbijanje ili otkazivanje šalje gostu obavijest i email.$refundNote',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            for (var i = 0; i < actions.length; i++) ...[
              if (i > 0) const SizedBox(width: 12),
              actions[i],
            ],
          ],
        ),
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
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _HistoryEntry extends StatelessWidget {
  const _HistoryEntry({required this.change});

  final ReservationStatusChange change;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = change.fromStatus == null
        ? 'Kreirana (${change.toStatus.label})'
        : '${change.fromStatus!.label} → ${change.toStatus.label}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: CircleAvatar(radius: 5, backgroundColor: reservationStatusColor(change.toStatus)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                Text(
                  '${Formatters.dateTime(change.changedAt)} · ${change.changedByFullName}',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                if (change.comment != null && change.comment!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text('„${change.comment}"', style: theme.textTheme.bodySmall),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
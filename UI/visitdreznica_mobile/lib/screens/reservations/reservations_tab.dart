import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../utils/item_type_ui.dart';
import '../../widgets/status_chip.dart';
import 'reservation_details_screen.dart';

enum _Filter {
  active('Aktivne', {ReservationStatus.pending, ReservationStatus.confirmed}),
  completed('Završene', {ReservationStatus.completed}),
  cancelled('Otkazane', {ReservationStatus.cancelled, ReservationStatus.rejected});

  const _Filter(this.label, this.statuses);

  final String label;
  final Set<ReservationStatus> statuses;
}

class ReservationsTab extends StatefulWidget {
  const ReservationsTab({super.key, required this.onExplore});

  final VoidCallback onExplore;

  @override
  State<ReservationsTab> createState() => ReservationsTabState();
}

class ReservationsTabState extends State<ReservationsTab> {
  late final ReservationService _service;

  _Filter _filter = _Filter.active;
  List<Reservation> _items = [];
  bool _loading = true;
  String? _error;
  int _requestId = 0;

  @override
  void initState() {
    super.initState();
    _service = ReservationService(context.read<ApiClient>());
    reload();
  }

  Future<void> reload() async {
    final requestId = ++_requestId;
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final page = await _service.getPage(ReservationSearch(statuses: _filter.statuses), pageSize: 50);
      if (!mounted || requestId != _requestId) return;
      setState(() => _items = page.items);
    } on ApiException catch (e) {
      if (mounted && requestId == _requestId) setState(() => _error = e.message);
    } finally {
      if (mounted && requestId == _requestId) setState(() => _loading = false);
    }
  }

  Future<void> _open(Reservation reservation) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => ReservationDetailsScreen(reservationId: reservation.id)),
    );
    if (mounted) reload();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: SizedBox(
            width: double.infinity,
            child: SegmentedButton<_Filter>(
              showSelectedIcon: false,
              segments: [
                for (final filter in _Filter.values) ButtonSegment(value: filter, label: Text(filter.label)),
              ],
              selected: {_filter},
              onSelectionChanged: (selection) {
                setState(() {
                  _filter = selection.first;
                  _items = [];
                });
                reload();
              },
            ),
          ),
        ),
        Expanded(child: _buildList()),
      ],
    );
  }

  Widget _buildList() {
    final theme = Theme.of(context);

    if (_loading && _items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              OutlinedButton(onPressed: reload, child: const Text('Pokušaj ponovo')),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: reload,
      child: _items.isEmpty
          ? ListView(
              children: [
                const SizedBox(height: 100),
                Icon(Icons.event_note_outlined, size: 56, color: theme.colorScheme.outline),
                const SizedBox(height: 12),
                Center(
                  child: Text(switch (_filter) {
                    _Filter.active => 'Nemate aktivnih rezervacija.',
                    _Filter.completed => 'Još nemate završenih rezervacija.',
                    _Filter.cancelled => 'Nemate otkazanih rezervacija.',
                  }),
                ),
                if (_filter == _Filter.active) ...[
                  const SizedBox(height: 12),
                  Center(
                    child: FilledButton.tonal(onPressed: widget.onExplore, child: const Text('Istraži ponudu')),
                  ),
                ],
              ],
            )
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final reservation = _items[index];
                return _ReservationCard(reservation: reservation, onTap: () => _open(reservation));
              },
            ),
    );
  }
}

class _ReservationCard extends StatelessWidget {
  const _ReservationCard({required this.reservation, required this.onTap});

  final Reservation reservation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final itemType = reservation.itemType;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(itemType.icon, color: itemType.color, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      reservation.itemName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(width: 8),
                  StatusChip(status: reservation.status),
                ],
              ),
              const SizedBox(height: 6),
              Text(reservation.periodLabel, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(reservation.quantityLabel, style: theme.textTheme.bodySmall),
                  const Spacer(),
                  Text(
                    Formatters.money(reservation.totalPrice),
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              if (reservation.awaitsPayment) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.credit_card_off_outlined, size: 16, color: theme.colorScheme.error),
                    const SizedBox(width: 6),
                    Text(
                      'Čeka plaćanje',
                      style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../widgets/paged_table.dart';
import '../../widgets/reservation_status_chip.dart';
import 'reservation_details_dialog.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  final _tableKey = GlobalKey<PagedTableState<Reservation>>();
  final _guestController = TextEditingController();
  late final ReservationService _service;

  Timer? _debounce;
  ReservationType? _type;
  final Set<ReservationStatus> _statuses = {};
  DateTimeRange? _range;
  int _queryVersion = 0;

  @override
  void initState() {
    super.initState();
    _service = ReservationService(context.read<ApiClient>());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _guestController.dispose();
    super.dispose();
  }

  ReservationSearch get _search => ReservationSearch(
        guestName: _guestController.text,
        type: _type,
        statuses: _statuses,
        from: _range?.start,
        to: _range?.end,
      );

  bool get _hasFilters =>
      _guestController.text.trim().isNotEmpty || _type != null || _statuses.isNotEmpty || _range != null;

  void _filtersChanged() => setState(() => _queryVersion++);

  void _onGuestChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _filtersChanged);
  }

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),
      initialDateRange: _range,
      helpText: 'Odaberite period',
    );

    if (picked != null) {
      _range = picked;
      _filtersChanged();
    }
  }

  void _clearFilters() {
    _debounce?.cancel();
    _guestController.clear();
    _type = null;
    _statuses.clear();
    _range = null;
    _filtersChanged();
  }

  Future<void> _openDetails(Reservation reservation) => showReservationDetailsDialog(
        context,
        reservation.id,
        onChanged: () => _tableKey.currentState?.reload(),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            _buildFilters(),
            const Divider(height: 1),
            Expanded(
              child: PagedTable<Reservation>(
                key: _tableKey,
                query: _queryVersion,
                load: (page, pageSize) => _service.getPage(_search, page: page, pageSize: pageSize),
                onRowTap: _openDetails,
                emptyText: _hasFilters ? 'Nema rezervacija za odabrane filtere.' : 'Još nema rezervacija.',
                columns: [
                  PagedColumn(header: '#', flex: 1, cell: (r) => Text('${r.id}')),
                  PagedColumn(header: 'Gost', flex: 3, cell: (r) => Text(r.userFullName)),
                  PagedColumn(header: 'Vrsta', flex: 2, cell: (r) => Text(r.type.label)),
                  PagedColumn(
                    header: 'Stavka',
                    flex: 4,
                    cell: (r) => Text(r.itemName, overflow: TextOverflow.ellipsis),
                  ),
                  PagedColumn(header: 'Termin', flex: 4, cell: (r) => Text(r.periodLabel)),
                  PagedColumn(
                    header: 'Iznos',
                    flex: 2,
                    alignEnd: true,
                    cell: (r) => Text(Formatters.money(r.totalPrice)),
                  ),
                  PagedColumn(
                    header: 'Plaćeno',
                    flex: 1,
                    alignEnd: true,
                    cell: (r) => Tooltip(
                      message: r.isPaid ? 'Plaćeno' : 'Nije plaćeno',
                      child: Icon(
                        r.isPaid ? Icons.check_circle : Icons.radio_button_unchecked,
                        size: 20,
                        color: r.isPaid ? const Color(0xFF16A34A) : Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                  PagedColumn(
                    header: 'Status',
                    flex: 2,
                    alignEnd: true,
                    cell: (r) => ReservationStatusChip(status: r.status),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 280,
                child: TextField(
                  controller: _guestController,
                  onChanged: _onGuestChanged,
                  decoration: const InputDecoration(
                    isDense: true,
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Ime ili prezime gosta',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 200,
                child: DropdownButtonFormField<ReservationType?>(
                  initialValue: _type,
                  isDense: true,
                  decoration: const InputDecoration(
                    labelText: 'Vrsta',
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Sve vrste')),
                    for (final type in ReservationType.values) DropdownMenuItem(value: type, child: Text(type.label)),
                  ],
                  onChanged: (value) {
                    _type = value;
                    _filtersChanged();
                  },
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: _pickRange,
                icon: const Icon(Icons.date_range),
                label: Text(_range == null
                    ? 'Period'
                    : '${Formatters.date(_range!.start)} – ${Formatters.date(_range!.end)}'),
              ),
              const Spacer(),
              if (_hasFilters)
                TextButton.icon(
                  onPressed: _clearFilters,
                  icon: const Icon(Icons.filter_alt_off_outlined),
                  label: const Text('Očisti filtere'),
                ),
              IconButton(
                tooltip: 'Osvježi',
                onPressed: () => _tableKey.currentState?.reload(),
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final status in ReservationStatus.values)
                FilterChip(
                  label: Text(status.label),
                  selected: _statuses.contains(status),
                  onSelected: (selected) {
                    selected ? _statuses.add(status) : _statuses.remove(status);
                    _filtersChanged();
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
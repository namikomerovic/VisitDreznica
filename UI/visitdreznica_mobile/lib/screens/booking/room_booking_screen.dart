import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../widgets/message_box.dart';
import 'booking_flow.dart';
import 'booking_widgets.dart';

class RoomBookingScreen extends StatefulWidget {
  const RoomBookingScreen({super.key, required this.roomId});

  final int roomId;

  @override
  State<RoomBookingScreen> createState() => _RoomBookingScreenState();
}

class _RoomBookingScreenState extends State<RoomBookingScreen> {
  final _note = TextEditingController();
  late final RoomService _rooms;
  late final BookingService _booking;

  Room? _room;
  String? _loadError;
  List<OccupiedPeriod> _occupied = [];

  DateTimeRange? _range;
  int _guests = 1;

  RoomQuote? _quote;
  String? _quoteError;
  bool _quoting = false;
  int _quoteRequest = 0;
  bool _submitting = false;

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  @override
  void initState() {
    super.initState();
    final api = context.read<ApiClient>();
    _rooms = RoomService(api);
    _booking = BookingService(api);
    _load();
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final today = _today();
      final room = await _rooms.getById(widget.roomId);
      final occupied = await _booking.roomOccupancy(widget.roomId, today, DateTime(today.year + 1, today.month, today.day));

      if (!mounted) return;
      setState(() {
        _room = room;
        _occupied = occupied;
        _guests = math.min(2, room.capacity);
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _loadError = e.message);
    }
  }

  bool _isOccupiedNight(DateTime day) => _occupied.any((p) => !day.isBefore(p.from) && day.isBefore(p.to));

  bool _isSelectable(DateTime day, DateTime? start, DateTime? end) {
    if (start != null && end == null && day.isAfter(start)) {
      for (var night = start; night.isBefore(day); night = DateTime(night.year, night.month, night.day + 1)) {
        if (_isOccupiedNight(night)) return false;
      }
      return true;
    }

    return !_isOccupiedNight(day);
  }

  Future<void> _pickDates() async {
    final today = _today();

    final picked = await showDateRangePicker(
      context: context,
      firstDate: today,
      lastDate: DateTime(today.year + 1, today.month, today.day),
      selectableDayPredicate: _isSelectable,
      helpText: 'Odaberite dolazak i odlazak',
      saveText: 'Potvrdi',
    );

    if (picked == null) return;
    setState(() => _range = picked);
    _refreshQuote();
  }

  Future<void> _refreshQuote() async {
    final range = _range;
    if (range == null) return;

    final requestId = ++_quoteRequest;
    setState(() {
      _quoting = true;
      _quoteError = null;
    });

    try {
      final quote = await _booking.quoteRoom(
        roomId: widget.roomId,
        checkIn: range.start,
        checkOut: range.end,
        guestCount: _guests,
      );

      if (!mounted || requestId != _quoteRequest) return;
      setState(() => _quote = quote);
    } on ApiException catch (e) {
      if (!mounted || requestId != _quoteRequest) return;
      setState(() {
        _quote = null;
        _quoteError = e.message;
      });
    } finally {
      if (mounted && requestId == _quoteRequest) setState(() => _quoting = false);
    }
  }

  Future<void> _submit() async {
    final range = _range!;
    setState(() => _submitting = true);

    await submitBooking(
      context,
      () => _booking.bookRoom(
        roomId: widget.roomId,
        checkIn: range.start,
        checkOut: range.end,
        guestCount: _guests,
        note: _note.text,
      ),
    );

    if (mounted) setState(() => _submitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final room = _room;

    if (room == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Rezervacija sobe')),
        body: Center(child: _loadError == null ? const CircularProgressIndicator() : Text(_loadError!)),
      );
    }

    final quote = _quote;
    final range = _range;

    return Scaffold(
      appBar: AppBar(title: const Text('Rezervacija sobe')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(room.name, style: theme.textTheme.headlineSmall),
          Text('${Formatters.money(room.pricePerNight)} / noć · do ${room.capacity} osoba',
              style: theme.textTheme.bodyMedium),
          const SizedBox(height: 24),
          Text('Termin boravka', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _submitting ? null : _pickDates,
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
            icon: const Icon(Icons.date_range),
            label: Text(range == null
                ? 'Odaberite datume'
                : '${Formatters.date(range.start)} – ${Formatters.date(range.end)}'),
          ),
          const SizedBox(height: 6),
          Text('Zauzeti dani su u kalendaru onemogućeni.', style: theme.textTheme.bodySmall),
          const SizedBox(height: 20),
          CounterField(
            label: 'Broj gostiju',
            value: _guests,
            min: 1,
            max: math.min(room.capacity, 10),
            onChanged: (value) {
              setState(() => _guests = value);
              _refreshQuote();
            },
          ),
          const SizedBox(height: 20),
          NoteField(controller: _note),
          const SizedBox(height: 8),
          if (_quoting) const LinearProgressIndicator(),
          if (_quoteError != null) MessageBox(text: _quoteError!, isError: true),
          if (quote != null)
            PriceSummary(
              rows: [
                PriceRow(
                  '${Formatters.money(quote.pricePerNight)} × ${quote.nights} ${countLabel(quote.nights, 'noć', 'noći', 'noći')}',
                  Formatters.money(quote.accommodationPrice),
                ),
                PriceRow('Boravišna taksa', Formatters.money(quote.touristTax)),
              ],
              total: Formatters.money(quote.totalPrice),
            ),
        ],
      ),
      bottomNavigationBar: BookingBar(
        total: quote == null ? null : Formatters.money(quote.totalPrice),
        busy: _submitting,
        onPressed: quote == null || _quoting ? null : _submit,
      ),
    );
  }
}
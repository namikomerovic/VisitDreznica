import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../widgets/message_box.dart';
import 'booking_flow.dart';
import 'booking_widgets.dart';

class EquipmentBookingScreen extends StatefulWidget {
  const EquipmentBookingScreen({super.key, required this.equipmentId});

  final int equipmentId;

  @override
  State<EquipmentBookingScreen> createState() => _EquipmentBookingScreenState();
}

class _EquipmentBookingScreenState extends State<EquipmentBookingScreen> {
  static const _maxHours = 12;
  static const _startHours = [7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18];

  final _note = TextEditingController();
  late final EquipmentService _equipmentService;
  late final BookingService _booking;

  Equipment? _equipment;
  String? _loadError;

  late DateTime _day;
  int _startHour = 9;
  int _hours = 2;
  int _quantity = 1;

  EquipmentQuote? _quote;
  String? _quoteError;
  bool _quoting = false;
  int _quoteRequest = 0;
  bool _submitting = false;

  DateTime get _start => DateTime(_day.year, _day.month, _day.day, _startHour);
  DateTime get _end => _start.add(Duration(hours: _hours));

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _day = DateTime(now.year, now.month, now.day + 1);

    final api = context.read<ApiClient>();
    _equipmentService = EquipmentService(api);
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
      final equipment = await _equipmentService.getById(widget.equipmentId);
      if (!mounted) return;
      setState(() => _equipment = equipment);
      _refreshQuote();
    } on ApiException catch (e) {
      if (mounted) setState(() => _loadError = e.message);
    }
  }

  Future<void> _pickDay() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: _day,
      firstDate: today,
      lastDate: DateTime(today.year, today.month + 3, today.day),
      helpText: 'Dan najma',
    );

    if (picked == null) return;
    setState(() => _day = picked);
    _refreshQuote();
  }

  void _change(VoidCallback update) {
    setState(update);
    _refreshQuote();
  }

  Future<void> _refreshQuote() async {
    final requestId = ++_quoteRequest;
    setState(() {
      _quoting = true;
      _quoteError = null;
    });

    try {
      final quote = await _booking.quoteEquipment(
        equipmentId: widget.equipmentId,
        start: _start,
        end: _end,
        quantity: _quantity,
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
    setState(() => _submitting = true);

    await submitBooking(
      context,
      () => _booking.bookEquipment(
        equipmentId: widget.equipmentId,
        start: _start,
        end: _end,
        quantity: _quantity,
        note: _note.text,
      ),
    );

    if (mounted) setState(() => _submitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final equipment = _equipment;

    if (equipment == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Najam opreme')),
        body: Center(child: _loadError == null ? const CircularProgressIndicator() : Text(_loadError!)),
      );
    }

    final quote = _quote;
    final canSubmit = quote != null && quote.isAvailable && !_quoting;

    return Scaffold(
      appBar: AppBar(title: const Text('Najam opreme')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(equipment.name, style: theme.textTheme.headlineSmall),
          Text(
            'Prvi sat ${Formatters.money(equipment.firstHourPrice)}, svaki sljedeći '
            '${Formatters.money(equipment.additionalHourPrice)}, cijeli dan najviše ${Formatters.money(equipment.fullDayPrice)}',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          Text('Dan i vrijeme preuzimanja', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _submitting ? null : _pickDay,
                  style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                  icon: const Icon(Icons.event),
                  label: Text(Formatters.date(_day)),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 120,
                child: DropdownButtonFormField<int>(
                  initialValue: _startHour,
                  decoration: const InputDecoration(labelText: 'Od', border: OutlineInputBorder()),
                  items: [
                    for (final hour in _startHours)
                      DropdownMenuItem(value: hour, child: Text('${hour.toString().padLeft(2, '0')}:00')),
                  ],
                  onChanged: _submitting ? null : (value) => _change(() => _startHour = value!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CounterField(
            label: 'Trajanje (sati)',
            value: _hours,
            min: 1,
            max: _maxHours,
            onChanged: (value) => _change(() => _hours = value),
          ),
          const SizedBox(height: 8),
          CounterField(
            label: 'Broj komada',
            value: _quantity,
            min: 1,
            max: math.min(equipment.totalQuantity, 20),
            onChanged: (value) => _change(() => _quantity = value),
          ),
          const SizedBox(height: 4),
          Text('Vraćanje: ${Formatters.dateTime(_end)}', style: theme.textTheme.bodySmall),
          const SizedBox(height: 20),
          NoteField(controller: _note),
          const SizedBox(height: 8),
          if (_quoting) const LinearProgressIndicator(),
          if (_quoteError != null) MessageBox(text: _quoteError!, isError: true),
          if (quote != null && !quote.isAvailable)
            MessageBox(
              text: 'U tom periodu slobodno je samo ${quote.availableQuantity} kom. Smanjite broj komada ili promijenite termin.',
              isError: true,
            ),
          if (quote != null)
            PriceSummary(
              rows: [
                PriceRow('Cijena po komadu (${quote.hours} h)', Formatters.money(quote.unitPrice)),
                PriceRow('Broj komada', '× ${quote.quantity}'),
              ],
              total: Formatters.money(quote.totalPrice),
            ),
        ],
      ),
      bottomNavigationBar: BookingBar(
        total: quote == null ? null : Formatters.money(quote.totalPrice),
        busy: _submitting,
        onPressed: canSubmit ? _submit : null,
      ),
    );
  }
}
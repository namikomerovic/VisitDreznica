import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import 'booking_flow.dart';
import 'booking_widgets.dart';

class ActivityBookingScreen extends StatefulWidget {
  const ActivityBookingScreen({super.key, required this.activityId});

  final int activityId;

  @override
  State<ActivityBookingScreen> createState() => _ActivityBookingScreenState();
}

class _ActivityBookingScreenState extends State<ActivityBookingScreen> {
  final _note = TextEditingController();
  late final ActivityService _activities;
  late final BookingService _booking;

  Activity? _activity;
  List<ActivitySlot> _slots = [];
  String? _loadError;

  ActivitySlot? _slot;
  int _participants = 1;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final api = context.read<ApiClient>();
    _activities = ActivityService(api);
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
      final activity = await _activities.getById(widget.activityId);
      final slots = await _activities.getSlots(activityId: widget.activityId, pageSize: 20);

      if (!mounted) return;

      final firstFree = slots.items.where((x) => x.availableSpots > 0);
      setState(() {
        _activity = activity;
        _slots = slots.items;
        _slot = firstFree.isEmpty ? null : firstFree.first;
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _loadError = e.message);
    }
  }

  int get _maxParticipants => math.min(_slot?.availableSpots ?? 1, 50);

  Future<void> _submit() async {
    final slot = _slot!;
    setState(() => _submitting = true);

    await submitBooking(
      context,
      () => _booking.bookActivity(activitySlotId: slot.id, participantCount: _participants, note: _note.text),
    );

    if (mounted) setState(() => _submitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activity = _activity;

    if (activity == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Rezervacija aktivnosti')),
        body: Center(child: _loadError == null ? const CircularProgressIndicator() : Text(_loadError!)),
      );
    }

    final total = activity.pricePerPerson * _participants;

    return Scaffold(
      appBar: AppBar(title: const Text('Rezervacija aktivnosti')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(activity.name, style: theme.textTheme.headlineSmall),
          Text(
            '${Formatters.money(activity.pricePerPerson)} po osobi · ${Formatters.duration(activity.durationMinutes)}',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          Text('Odaberite termin', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          if (_slots.isEmpty) const Text('Trenutno nema zakazanih termina.'),
          for (final slot in _slots)
            ListTile(
              contentPadding: EdgeInsets.zero,
              enabled: slot.availableSpots > 0 && !_submitting,
              onTap: () => setState(() {
                _slot = slot;
                _participants = math.min(_participants, math.min(slot.availableSpots, 50));
              }),
              leading: Icon(
                _slot?.id == slot.id ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: _slot?.id == slot.id ? theme.colorScheme.primary : null,
              ),
              title: Text(Formatters.dateTime(slot.startTime)),
              subtitle: Text('Vodič: ${slot.guideFullName}'),
              trailing: Text(slot.availableSpots == 0 ? 'Popunjeno' : 'Slobodno: ${slot.availableSpots}'),
            ),
          if (_slot != null) ...[
            const SizedBox(height: 16),
            CounterField(
              label: 'Broj osoba',
              value: _participants,
              min: 1,
              max: _maxParticipants,
              onChanged: (value) => setState(() => _participants = value),
            ),
            if (activity.meetingPoint != null && activity.meetingPoint!.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Mjesto okupljanja: ${activity.meetingPoint}', style: theme.textTheme.bodySmall),
            ],
            const SizedBox(height: 20),
            NoteField(controller: _note),
            const SizedBox(height: 8),
            PriceSummary(
              rows: [
                PriceRow(
                  '${Formatters.money(activity.pricePerPerson)} × $_participants ${countLabel(_participants, 'osoba', 'osobe', 'osoba')}',
                  Formatters.money(total),
                ),
              ],
              total: Formatters.money(total),
            ),
          ],
        ],
      ),
      bottomNavigationBar: BookingBar(
        total: _slot == null ? null : Formatters.money(total),
        busy: _submitting,
        onPressed: _slot == null ? null : _submit,
      ),
    );
  }
}
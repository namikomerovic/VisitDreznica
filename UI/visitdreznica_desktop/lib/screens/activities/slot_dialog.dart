import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';


import '../../widgets/dialogs.dart';

Future<bool> showSlotDialog(
  BuildContext context, {
  required Activity activity,
  required List<Guide> guides,
  ActivitySlot? slot,
}) async {
  final changed = await showDialog<bool>(
    context: context,
    builder: (_) => SlotDialog(activity: activity, guides: guides, slot: slot),
  );

  return changed == true;
}

class SlotDialog extends StatefulWidget {
  const SlotDialog({super.key, required this.activity, required this.guides, this.slot});

  final Activity activity;
  final List<Guide> guides;
  final ActivitySlot? slot;

  @override
  State<SlotDialog> createState() => _SlotDialogState();
}

class _SlotDialogState extends State<SlotDialog> {
  final _formKey = GlobalKey<FormState>();
  final _capacityController = TextEditingController();
  late final ActivityService _service;

  DateTime? _date;
  TimeOfDay? _time;
  int? _guideId;
  bool _saving = false;
  String? _error;

  ActivitySlot? get _slot => widget.slot;
  bool get _isEdit => _slot != null;
  bool get _started => _slot?.hasStarted ?? false;
  int get _booked => _slot?.bookedCount ?? 0;
  bool get _canChangeTime => !_started && _booked == 0;

  DateTime? get _start => _date == null || _time == null
      ? null
      : DateTime(_date!.year, _date!.month, _date!.day, _time!.hour, _time!.minute);

  @override
  void initState() {
    super.initState();
    _service = ActivityService(context.read<ApiClient>());

    final slot = _slot;

    if (slot != null) {
      final local = slot.startTime.toLocal();
      _date = DateTime(local.year, local.month, local.day);
      _time = TimeOfDay.fromDateTime(local);
      _capacityController.text = '${slot.capacity}';
      _guideId = slot.guideId;
    } else {
      _capacityController.text = '${widget.activity.maxParticipants}';
      _guideId = widget.guides.length == 1 ? widget.guides.first.id : null;
    }
  }

  @override
  void dispose() {
    _capacityController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(today.year, today.month, today.day),
      lastDate: today.add(const Duration(days: 365)),
      initialDate: _date != null && !_date!.isBefore(DateTime(today.year, today.month, today.day)) ? _date! : today,
    );

    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 9, minute: 0),
    );

    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _save() async {
    setState(() => _error = null);

    if (!_formKey.currentState!.validate()) return;

    final start = _start;

    if (start == null) {
      setState(() => _error = 'Odaberite datum i vrijeme početka.');
      return;
    }

    if (_canChangeTime && !start.isAfter(DateTime.now())) {
      setState(() => _error = 'Termin mora biti u budućnosti.');
      return;
    }

    final request = ActivitySlotRequest(
      startTime: start,
      capacity: int.parse(_capacityController.text),
      guideId: _guideId!,
    );

    setState(() => _saving = true);

    try {
      if (_isEdit) {
        await _service.updateSlot(_slot!.id, request);
      } else {
        await _service.insertSlot(widget.activity.id, request);
      }

      if (mounted) Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Brisanje termina',
      message: 'Obrisati termin ${Formatters.dateTime(_slot!.startTime)}?',
      confirmLabel: 'Obriši',
      destructive: true,
    );

    if (!confirmed) return;

    setState(() => _saving = true);

    try {
      await _service.deleteSlot(_slot!.id);
      if (mounted) Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final start = _start;
    final end = start?.add(Duration(minutes: widget.activity.durationMinutes));

    return AlertDialog(
      title: Text(_isEdit ? 'Termin' : 'Novi termin'),
      content: SizedBox(
        width: 440,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(widget.activity.name, style: theme.textTheme.titleSmall),
              const SizedBox(height: 12),
              if (_started)
                const _Info('Termin je već počeo ili završio i ne može se mijenjati.')
              else if (_booked > 0)
                _Info('Termin ima $_booked rezervisanih mjesta. Vrijeme se ne može mijenjati, '
                    'a kapacitet ne može biti manji od $_booked.'),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _canChangeTime && !_saving ? _pickDate : null,
                      icon: const Icon(Icons.calendar_today_outlined),
                      label: Text(_date == null ? 'Datum *' : Formatters.date(_date!)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _canChangeTime && !_saving ? _pickTime : null,
                      icon: const Icon(Icons.schedule),
                      label: Text(_time == null ? 'Vrijeme *' : _time!.format(context)),
                    ),
                  ),
                ],
              ),
              if (end != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Završava u ${Formatters.time(end)} (trajanje ${Formatters.duration(widget.activity.durationMinutes)}).',
                  style: theme.textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                controller: _capacityController,
                enabled: !_started && !_saving,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'Kapacitet *',
                  helperText: 'Najviše ${widget.activity.maxParticipants} (maksimum aktivnosti)',
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  final min = _booked > 0 ? _booked : 1;
                  return validateIntRange(value, min, widget.activity.maxParticipants,
                      'Između $min i ${widget.activity.maxParticipants}.');
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                initialValue: _guideId,
                decoration: const InputDecoration(labelText: 'Vodič *', border: OutlineInputBorder()),
                items: [for (final guide in widget.guides) DropdownMenuItem(value: guide.id, child: Text(guide.fullName))],
                onChanged: _started || _saving ? null : (value) => setState(() => _guideId = value),
                validator: (value) => value == null ? 'Odaberite vodiča.' : null,
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_error!, style: TextStyle(color: theme.colorScheme.onErrorContainer)),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        if (_isEdit && !_started && _booked == 0)
          TextButton(
            onPressed: _saving ? null : _delete,
            child: Text('Obriši', style: TextStyle(color: theme.colorScheme.error)),
          ),
        TextButton(onPressed: _saving ? null : () => Navigator.pop(context, false), child: const Text('Odustani')),
        FilledButton(
          onPressed: _started || _saving ? null : _save,
          child: _saving
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Sačuvaj'),
        ),
      ],
    );
  }
}

class _Info extends StatelessWidget {
  const _Info(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: scheme.secondaryContainer, borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: TextStyle(color: scheme.onSecondaryContainer)),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../widgets/paged_table.dart';
import 'slot_dialog.dart';

class ActivitySlotsSection extends StatefulWidget {
  const ActivitySlotsSection({super.key, required this.activity, required this.guides, required this.onChanged});

  final Activity activity;
  final List<Guide> guides;
  final VoidCallback onChanged;

  @override
  State<ActivitySlotsSection> createState() => _ActivitySlotsSectionState();
}

class _ActivitySlotsSectionState extends State<ActivitySlotsSection> {
  final _tableKey = GlobalKey<PagedTableState<ActivitySlot>>();
  late final ActivityService _service;
  bool _onlyUpcoming = true;

  @override
  void initState() {
    super.initState();
    _service = ActivityService(context.read<ApiClient>());
  }

  Future<void> _open({ActivitySlot? slot}) async {
    final changed = await showSlotDialog(context, activity: widget.activity, guides: widget.guides, slot: slot);

    if (changed) {
      _tableKey.currentState?.reload();
      widget.onChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(tr.slots, style: theme.textTheme.titleMedium),
            const Spacer(),
            FilterChip(
              label: Text(tr.onlyUpcoming),
              selected: _onlyUpcoming,
              onSelected: (value) => setState(() => _onlyUpcoming = value),
            ),
            const SizedBox(width: 12),
            FilledButton.tonalIcon(
              onPressed: widget.guides.isEmpty ? null : () => _open(),
              icon: const Icon(Icons.add),
              label: Text(tr.addSlot),
            ),
          ],
        ),
        if (widget.guides.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(tr.addGuideFirst, style: theme.textTheme.bodySmall),
          ),
        const SizedBox(height: 12),
        SizedBox(
          height: 460,
          child: PagedTable<ActivitySlot>(
            key: _tableKey,
            query: _onlyUpcoming,
            load: (page, pageSize) => _service.getSlots(
              activityId: widget.activity.id,
              onlyUpcoming: _onlyUpcoming,
              page: page,
              pageSize: pageSize,
            ),
            onRowTap: (slot) => _open(slot: slot),
            emptyText: _onlyUpcoming ? tr.noUpcomingSlots : tr.noSlotsShort,
            columns: [
              PagedColumn(header: tr.start, flex: 3, cell: (slot) => Text(Formatters.dateTime(slot.startTime))),
              PagedColumn(header: tr.end, flex: 2, cell: (slot) => Text(Formatters.time(slot.endTime))),
              PagedColumn(header: tr.guide, flex: 3, cell: (slot) => Text(slot.guideFullName)),
              PagedColumn(
                header: tr.booked,
                flex: 2,
                alignEnd: true,
                cell: (slot) => Text('${slot.bookedCount} / ${slot.capacity}'),
              ),
              PagedColumn(
                header: tr.available,
                flex: 2,
                alignEnd: true,
                cell: (slot) => Text(
                  slot.hasStarted ? '—' : '${slot.availableSpots}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: slot.availableSpots == 0 && !slot.hasStarted ? theme.colorScheme.error : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
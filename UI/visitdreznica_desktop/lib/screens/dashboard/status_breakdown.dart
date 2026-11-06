import 'package:flutter/material.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

class StatusBreakdown extends StatelessWidget {
  const StatusBreakdown({super.key, required this.data});

  final List<StatusCount> data;

  static Color colorFor(ReservationStatus status) => switch (status) {
        ReservationStatus.pending => const Color(0xFFF59E0B),
        ReservationStatus.confirmed => const Color(0xFF3B82F6),
        ReservationStatus.completed => const Color(0xFF16A34A),
        ReservationStatus.cancelled => const Color(0xFF9CA3AF),
        ReservationStatus.rejected => const Color(0xFFDC2626),
      };

  @override
  Widget build(BuildContext context) {
    final counts = {for (final item in data) item.status: item.count};
    final total = counts.values.fold<int>(0, (sum, value) => sum + value);

    return Column(
      children: [
        for (final status in ReservationStatus.values)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(status.label)),
                    Text('${counts[status] ?? 0}', style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: total == 0 ? 0 : (counts[status] ?? 0) / total,
                    minHeight: 8,
                    color: colorFor(status),
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
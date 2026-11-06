import 'package:flutter/material.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

Color reservationStatusColor(ReservationStatus status) => switch (status) {
      ReservationStatus.pending => const Color(0xFFF59E0B),
      ReservationStatus.confirmed => const Color(0xFF3B82F6),
      ReservationStatus.completed => const Color(0xFF16A34A),
      ReservationStatus.cancelled => const Color(0xFF6B7280),
      ReservationStatus.rejected => const Color(0xFFDC2626),
    };

class ReservationStatusChip extends StatelessWidget {
  const ReservationStatusChip({super.key, required this.status});

  final ReservationStatus status;

  @override
  Widget build(BuildContext context) {
    final color = reservationStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.label,
        style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }
}
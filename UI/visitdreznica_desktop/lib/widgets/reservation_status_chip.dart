import 'package:flutter/material.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

Color reservationStatusColor(ReservationStatus status) => AppColors.forStatus(status);

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
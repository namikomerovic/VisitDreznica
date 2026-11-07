import 'package:flutter/material.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

extension ReservationStatusUi on ReservationStatus {
  Color get color => switch (this) {
        ReservationStatus.pending => const Color(0xFFF59E0B),
        ReservationStatus.confirmed => const Color(0xFF16A34A),
        ReservationStatus.completed => const Color(0xFF2563EB),
        ReservationStatus.cancelled => const Color(0xFF6B7280),
        ReservationStatus.rejected => const Color(0xFFDC2626),
      };

  IconData get icon => switch (this) {
        ReservationStatus.pending => Icons.hourglass_top,
        ReservationStatus.confirmed => Icons.check_circle_outline,
        ReservationStatus.completed => Icons.task_alt,
        ReservationStatus.cancelled => Icons.cancel_outlined,
        ReservationStatus.rejected => Icons.block,
      };
}
import 'package:flutter/material.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

extension ReservationStatusUi on ReservationStatus {
  Color get color => AppColors.forStatus(this);

  IconData get icon => switch (this) {
    ReservationStatus.pending => Icons.hourglass_top,
    ReservationStatus.confirmed => Icons.check_circle_outline,
    ReservationStatus.completed => Icons.task_alt,
    ReservationStatus.cancelled => Icons.cancel_outlined,
    ReservationStatus.rejected => Icons.block,
  };
}

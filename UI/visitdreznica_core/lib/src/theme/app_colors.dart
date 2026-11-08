import 'package:flutter/material.dart';

import '../models/item_type.dart';
import '../models/reservation_status.dart';

abstract final class AppColors {
  // Boje iz loga Visit Drežnica
  static const brandRed = Color(0xFFEF4734);
  static const brandYellow = Color(0xFFFAF6B1);
  static const brandGreen = Color(0xFF8CCA74);
  static const brandBlue = Color(0xFF6BB0E1);

  // Vrste stavki – tamnije nijanse boja iz loga, čitljive na svijetloj i tamnoj pozadini
  static const room = Color(0xFF3A8FD1);
  static const equipment = Color(0xFF4FA341);
  static const activity = Color(0xFFD9A300);
  static const place = Color(0xFFE5533F);

  // Značenja
  static const success = Color(0xFF22A55A);
  static const warning = Color(0xFFF59E0B);
  static const danger = Color(0xFFE5484D);
  static const info = Color(0xFF3B82F6);
  static const neutral = Color(0xFF8B95A1);
  static const star = Color(0xFFF5A623);

  static Color forItemType(ItemType type) => switch (type) {
        ItemType.room => room,
        ItemType.equipment => equipment,
        ItemType.activity => activity,
        ItemType.place => place,
      };

  static Color forStatus(ReservationStatus status) => switch (status) {
        ReservationStatus.pending => warning,
        ReservationStatus.confirmed => info,
        ReservationStatus.completed => success,
        ReservationStatus.cancelled => neutral,
        ReservationStatus.rejected => danger,
      };
}
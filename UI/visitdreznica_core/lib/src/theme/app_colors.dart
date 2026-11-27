import 'package:flutter/material.dart';

import '../models/item_type.dart';
import '../models/reservation_status.dart';

abstract final class AppColors {
  // Paleta: šumsko zelena (osnovna), terakota (glavne akcije), topla krem pozadina
  static const forest = Color(0xFF1F3D2E);
  static const forestDeep = Color(0xFF172E23);
  static const forestSoft = Color(0xFFE3ECE5);
  static const sage = Color(0xFF5B6F62);
  static const terracotta = Color(0xFFC4572E);
  static const terracottaSoft = Color(0xFFF6E3DA);
  static const cream = Color(0xFFF7F5EF);
  static const sand = Color(0xFFE6E2D8);
  static const ink = Color(0xFF1C1F1D);
  static const muted = Color(0xFF6B6F68);

  // Tamni način
  static const nightBackground = Color(0xFF111714);
  static const nightSurface = Color(0xFF19211D);
  static const nightCard = Color(0xFF1F2924);
  static const nightForest = Color(0xFF8FC2A2);
  static const nightTerracotta = Color(0xFFE07A50);

  // Glavne akcije (Rezerviši, Plati, Prijavi se) – terakota, i u tamnom načinu
  static Color cta(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? nightTerracotta : terracotta;

  // Vrste stavki – prigušeni tonovi koji se slažu s paletom
  static const room = Color(0xFF4A7FA6);
  static const equipment = Color(0xFF5E8F4E);
  static const activity = Color(0xFFC18A1E);
  static const place = Color(0xFFB5523B);

  // Značenja
  static const success = Color(0xFF2E8B57);
  static const warning = Color(0xFFD9930D);
  static const danger = Color(0xFFD64545);
  static const info = Color(0xFF3F7CAC);
  static const neutral = Color(0xFF8B918A);
  static const star = Color(0xFFF2A922);

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

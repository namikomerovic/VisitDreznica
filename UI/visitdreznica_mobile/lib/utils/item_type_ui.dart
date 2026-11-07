import 'package:flutter/material.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

extension ItemTypeUi on ItemType {
  IconData get icon => switch (this) {
        ItemType.room => Icons.bed_outlined,
        ItemType.equipment => Icons.kayaking,
        ItemType.activity => Icons.hiking,
        ItemType.place => Icons.place_outlined,
      };

  Color get color => switch (this) {
        ItemType.room => const Color(0xFF0F766E),
        ItemType.equipment => const Color(0xFF2563EB),
        ItemType.activity => const Color(0xFFEA580C),
        ItemType.place => const Color(0xFF16A34A),
      };

  String get pluralLabel => switch (this) {
        ItemType.room => 'Sobe',
        ItemType.equipment => 'Oprema',
        ItemType.activity => 'Aktivnosti',
        ItemType.place => 'Mjesta',
      };
}
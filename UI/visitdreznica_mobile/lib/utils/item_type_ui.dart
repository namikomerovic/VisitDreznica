import 'package:flutter/material.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

extension ItemTypeUi on ItemType {
  IconData get icon => switch (this) {
        ItemType.room => Icons.bed_outlined,
        ItemType.equipment => Icons.kayaking,
        ItemType.activity => Icons.hiking,
        ItemType.place => Icons.place_outlined,
      };

  Color get color => AppColors.forItemType(this);

  String get pluralLabel => switch (this) {
        ItemType.room => 'Sobe',
        ItemType.equipment => 'Oprema',
        ItemType.activity => 'Aktivnosti',
        ItemType.place => 'Mjesta',
      };
}
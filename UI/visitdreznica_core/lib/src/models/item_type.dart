import '../l10n/locale_controller.dart';

enum ItemType {
  room(1),
  equipment(2),
  activity(3),
  place(4);

  const ItemType(this.value);

  final int value;

  String get label => switch (this) {
        ItemType.room => tr.itemRoom,
        ItemType.equipment => tr.itemEquipment,
        ItemType.activity => tr.itemActivity,
        ItemType.place => tr.itemPlace,
      };

  String get pluralLabel => switch (this) {
        ItemType.room => tr.itemRooms,
        ItemType.equipment => tr.itemEquipmentPlural,
        ItemType.activity => tr.itemActivities,
        ItemType.place => tr.itemPlaces,
      };

  static ItemType fromValue(int value) => values.firstWhere((x) => x.value == value);
}

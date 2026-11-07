enum ItemType {
  room(1, 'Soba'),
  equipment(2, 'Oprema'),
  activity(3, 'Aktivnost'),
  place(4, 'Mjesto');

  const ItemType(this.value, this.label);

  final int value;
  final String label;

  static ItemType fromValue(int value) => values.firstWhere((x) => x.value == value);
}
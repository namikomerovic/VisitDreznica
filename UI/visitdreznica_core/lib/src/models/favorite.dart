import 'item_type.dart';

class Favorite {
  Favorite({
    required this.id,
    required this.itemType,
    required this.itemId,
    required this.itemName,
    required this.createdAt,
  });

  final int id;
  final ItemType itemType;
  final int itemId;
  final String itemName;
  final DateTime createdAt;

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
        id: json['id'] as int,
        itemType: ItemType.fromValue(json['itemType'] as int),
        itemId: json['itemId'] as int,
        itemName: json['itemName'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
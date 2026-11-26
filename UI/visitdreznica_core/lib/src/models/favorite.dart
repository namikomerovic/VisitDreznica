import 'item_type.dart';

class Favorite {
  Favorite({
    required this.id,
    required this.itemType,
    required this.itemId,
    required this.itemName,
    required this.createdAt,
    this.coverImageId,
    this.hasImage = false,
  });

  final int id;
  final ItemType itemType;
  final int itemId;
  final String itemName;
  final DateTime createdAt;
  final int? coverImageId;
  final bool hasImage;

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
        id: json['id'] as int,
        itemType: ItemType.fromValue(json['itemType'] as int),
        itemId: json['itemId'] as int,
        itemName: json['itemName'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        coverImageId: json['coverImageId'] as int?,
        hasImage: json['hasImage'] as bool? ?? false,
      );
}
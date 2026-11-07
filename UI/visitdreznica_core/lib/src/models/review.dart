import 'item_type.dart';
export 'item_type.dart';

class Review {
  Review({
    required this.id,
    required this.itemType,
    required this.itemId,
    required this.itemName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.userId,
    required this.userFullName,
  });

  final int id;
  final ItemType itemType;
  final int itemId;
  final String itemName;
  final int rating;
  final String? comment;
  final DateTime createdAt;
  final int userId;
  final String userFullName;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json['id'] as int,
        itemType: ItemType.fromValue(json['itemType'] as int),
        itemId: json['itemId'] as int,
        itemName: json['itemName'] as String,
        rating: json['rating'] as int,
        comment: json['comment'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        userId: json['userId'] as int,
        userFullName: json['userFullName'] as String,
      );
}
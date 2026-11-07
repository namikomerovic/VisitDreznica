import 'item_type.dart';

class Recommendation {
  Recommendation({
    required this.itemType,
    required this.itemId,
    required this.itemName,
    required this.score,
    required this.reason,
    required this.isPersonalized,
  });

  final ItemType itemType;
  final int itemId;
  final String itemName;
  final double score;
  final String reason;
  final bool isPersonalized;

  factory Recommendation.fromJson(Map<String, dynamic> json) => Recommendation(
        itemType: ItemType.fromValue(json['itemType'] as int),
        itemId: json['itemId'] as int,
        itemName: json['itemName'] as String,
        score: (json['score'] as num).toDouble(),
        reason: json['reason'] as String,
        isPersonalized: json['isPersonalized'] as bool,
      );
}

class ReviewSummaryItem {
  ReviewSummaryItem({required this.itemId, required this.averageRating, required this.reviewCount});

  final int itemId;
  final double averageRating;
  final int reviewCount;

  factory ReviewSummaryItem.fromJson(Map<String, dynamic> json) => ReviewSummaryItem(
        itemId: json['itemId'] as int,
        averageRating: (json['averageRating'] as num).toDouble(),
        reviewCount: json['reviewCount'] as int,
      );
}
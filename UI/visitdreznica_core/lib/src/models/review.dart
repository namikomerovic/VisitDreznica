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

class ReviewSummary {
  ReviewSummary({
    required this.averageRating,
    required this.reviewCount,
    required this.ratingCounts,
    required this.canReview,
    required this.myReview,
  });

  final double? averageRating;
  final int reviewCount;
  final List<int> ratingCounts;
  final bool canReview;
  final Review? myReview;

  factory ReviewSummary.fromJson(Map<String, dynamic> json) => ReviewSummary(
        averageRating: (json['averageRating'] as num?)?.toDouble(),
        reviewCount: json['reviewCount'] as int,
        ratingCounts: (json['ratingCounts'] as List<dynamic>).map((x) => x as int).toList(),
        canReview: json['canReview'] as bool,
        myReview: json['myReview'] == null ? null : Review.fromJson(json['myReview'] as Map<String, dynamic>),
      );
}
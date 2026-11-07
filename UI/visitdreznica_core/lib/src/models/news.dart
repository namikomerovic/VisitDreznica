class NewsItem {
  NewsItem({
    required this.id,
    required this.title,
    required this.content,
    required this.publishedAt,
    required this.hasImage,
    required this.isPublished,
    required this.createdByFullName,
  });

  final int id;
  final String title;
  final String content;
  final DateTime publishedAt;
  final bool hasImage;
  final bool isPublished;
  final String createdByFullName;

  factory NewsItem.fromJson(Map<String, dynamic> json) => NewsItem(
        id: json['id'] as int,
        title: json['title'] as String,
        content: json['content'] as String,
        publishedAt: DateTime.parse(json['publishedAt'] as String),
        hasImage: json['hasImage'] as bool,
        isPublished: json['isPublished'] as bool,
        createdByFullName: json['createdByFullName'] as String,
      );
}

class NewsUpsertRequest {
  NewsUpsertRequest({required this.title, required this.content, required this.publishedAt});

  final String title;
  final String content;
  final DateTime publishedAt;

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'publishedAt': publishedAt.toUtc().toIso8601String(),
      };
}
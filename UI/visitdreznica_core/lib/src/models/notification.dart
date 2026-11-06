enum NotificationType {
  reservation(1),
  payment(2),
  system(3);

  const NotificationType(this.value);

  final int value;

  static NotificationType fromValue(int value) =>
      values.firstWhere((x) => x.value == value, orElse: () => NotificationType.system);
}

class AppNotification {
  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.reservationId,
    required this.isRead,
    required this.createdAt,
  });

  final int id;
  final String title;
  final String message;
  final NotificationType type;
  final int? reservationId;
  final bool isRead;
  final DateTime createdAt;

  AppNotification markedAsRead() => AppNotification(
        id: id,
        title: title,
        message: message,
        type: type,
        reservationId: reservationId,
        isRead: true,
        createdAt: createdAt,
      );

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
        id: json['id'] as int,
        title: json['title'] as String,
        message: json['message'] as String,
        type: NotificationType.fromValue(json['type'] as int),
        reservationId: json['reservationId'] as int?,
        isRead: json['isRead'] as bool,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
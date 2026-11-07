import '../utils/formatters.dart';
import 'reservation_status.dart';
import 'item_type.dart';

enum ReservationType {
  room(1, 'Smještaj'),
  equipment(2, 'Najam opreme'),
  activity(3, 'Aktivnost');

  const ReservationType(this.value, this.label);

  final int value;
  final String label;

  static ReservationType fromValue(int value) =>
      values.firstWhere((x) => x.value == value);
}

class Reservation {
  Reservation({
    required this.id,
    required this.type,
    required this.status,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.isPaid,
    required this.note,
    required this.createdAt,
    required this.userId,
    required this.userFullName,
    required this.itemName,
    required this.guestCount,
    required this.quantity,
    required this.participantCount,
    required this.statusHistory,
    this.roomId,
    this.equipmentId,
    this.activityId,
    this.activitySlotId,
  });

  final int id;
  final ReservationType type;
  final ReservationStatus status;
  final DateTime startTime;
  final DateTime endTime;
  final double totalPrice;
  final bool isPaid;
  final String? note;
  final DateTime createdAt;
  final int userId;
  final String userFullName;
  final String itemName;
  final int? guestCount;
  final int? quantity;
  final int? participantCount;
  final List<ReservationStatusChange> statusHistory;
  final int? roomId;
  final int? equipmentId;
  final int? activityId;
  final int? activitySlotId;

  ItemType get itemType => switch (type) {
    ReservationType.room => ItemType.room,
    ReservationType.equipment => ItemType.equipment,
    ReservationType.activity => ItemType.activity,
  };

  int? get itemId => roomId ?? equipmentId ?? activityId;

  bool get isActive =>
      status == ReservationStatus.pending ||
      status == ReservationStatus.confirmed;

  bool get awaitsPayment => status == ReservationStatus.pending && !isPaid;

  String get periodLabel {
    if (type == ReservationType.room) {
      return '${Formatters.date(startTime)} – ${Formatters.date(endTime)}';
    }

    final start = startTime.toLocal();
    final end = endTime.toLocal();
    final sameDay =
        start.year == end.year &&
        start.month == end.month &&
        start.day == end.day;

    return sameDay
        ? '${Formatters.dateTime(startTime)} – ${Formatters.time(endTime)}'
        : '${Formatters.dateTime(startTime)} – ${Formatters.dateTime(endTime)}';
  }

  String get quantityLabel => switch (type) {
    ReservationType.room => 'Gostiju: ${guestCount ?? 0}',
    ReservationType.equipment => 'Komada: ${quantity ?? 0}',
    ReservationType.activity => 'Učesnika: ${participantCount ?? 0}',
  };

  factory Reservation.fromJson(Map<String, dynamic> json) => Reservation(
    id: json['id'] as int,
    type: ReservationType.fromValue(json['type'] as int),
    status: ReservationStatus.fromValue(json['status'] as int),
    startTime: DateTime.parse(json['startTime'] as String),
    endTime: DateTime.parse(json['endTime'] as String),
    totalPrice: (json['totalPrice'] as num).toDouble(),
    isPaid: json['isPaid'] as bool,
    note: json['note'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    userId: json['userId'] as int,
    userFullName: json['userFullName'] as String,
    itemName: json['itemName'] as String,
    guestCount: json['guestCount'] as int?,
    quantity: json['quantity'] as int?,
    participantCount: json['participantCount'] as int?,
    statusHistory: (json['statusHistory'] as List<dynamic>? ?? const [])
        .map((x) => ReservationStatusChange.fromJson(x as Map<String, dynamic>))
        .toList(),
    roomId: json['roomId'] as int?,
    equipmentId: json['equipmentId'] as int?,
    activityId: json['activityId'] as int?,
    activitySlotId: json['activitySlotId'] as int?,
  );
}

class ReservationStatusChange {
  ReservationStatusChange({
    required this.fromStatus,
    required this.toStatus,
    required this.changedAt,
    required this.changedByFullName,
    required this.comment,
  });

  final ReservationStatus? fromStatus;
  final ReservationStatus toStatus;
  final DateTime changedAt;
  final String changedByFullName;
  final String? comment;

  factory ReservationStatusChange.fromJson(Map<String, dynamic> json) =>
      ReservationStatusChange(
        fromStatus: json['fromStatus'] == null
            ? null
            : ReservationStatus.fromValue(json['fromStatus'] as int),
        toStatus: ReservationStatus.fromValue(json['toStatus'] as int),
        changedAt: DateTime.parse(json['changedAt'] as String),
        changedByFullName: json['changedByFullName'] as String,
        comment: json['comment'] as String?,
      );
}

class ReservationSearch {
  ReservationSearch({
    this.guestName,
    this.type,
    this.statuses = const {},
    this.from,
    this.to,
  });

  final String? guestName;
  final ReservationType? type;
  final Set<ReservationStatus> statuses;
  final DateTime? from;
  final DateTime? to;

  Map<String, dynamic> toQuery({required int page, required int pageSize}) {
    final name = guestName?.trim();

    return {
      'page': page,
      'pageSize': pageSize,
      if (name != null && name.isNotEmpty) 'guestName': name,
      if (type != null) 'type': type!.value,
      if (statuses.isNotEmpty)
        'statuses': statuses.map((x) => x.value).toList(),
      if (from != null)
        'from': DateTime(
          from!.year,
          from!.month,
          from!.day,
        ).toUtc().toIso8601String(),
      if (to != null)
        'to': DateTime(
          to!.year,
          to!.month,
          to!.day,
          23,
          59,
          59,
        ).toUtc().toIso8601String(),
    };
  }
}

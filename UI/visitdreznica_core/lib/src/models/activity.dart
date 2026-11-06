class Activity {
  Activity({
    required this.id,
    required this.name,
    required this.description,
    required this.activityCategoryId,
    required this.activityCategoryName,
    required this.durationMinutes,
    required this.maxParticipants,
    required this.pricePerPerson,
    required this.meetingPoint,
    required this.isActive,
    required this.hasImage,
    required this.nextSlotStart,
  });

  final int id;
  final String name;
  final String? description;
  final int activityCategoryId;
  final String activityCategoryName;
  final int durationMinutes;
  final int maxParticipants;
  final double pricePerPerson;
  final String? meetingPoint;
  final bool isActive;
  final bool hasImage;
  final DateTime? nextSlotStart;

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        id: json['id'] as int,
        name: json['name'] as String,
        description: json['description'] as String?,
        activityCategoryId: json['activityCategoryId'] as int,
        activityCategoryName: json['activityCategoryName'] as String,
        durationMinutes: json['durationMinutes'] as int,
        maxParticipants: json['maxParticipants'] as int,
        pricePerPerson: (json['pricePerPerson'] as num).toDouble(),
        meetingPoint: json['meetingPoint'] as String?,
        isActive: json['isActive'] as bool,
        hasImage: json['hasImage'] as bool,
        nextSlotStart: json['nextSlotStart'] == null ? null : DateTime.parse(json['nextSlotStart'] as String),
      );
}

class ActivityUpsertRequest {
  ActivityUpsertRequest({
    required this.name,
    required this.description,
    required this.activityCategoryId,
    required this.durationMinutes,
    required this.maxParticipants,
    required this.pricePerPerson,
    required this.meetingPoint,
    required this.isActive,
  });

  final String name;
  final String? description;
  final int activityCategoryId;
  final int durationMinutes;
  final int maxParticipants;
  final double pricePerPerson;
  final String? meetingPoint;
  final bool isActive;

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'activityCategoryId': activityCategoryId,
        'durationMinutes': durationMinutes,
        'maxParticipants': maxParticipants,
        'pricePerPerson': pricePerPerson,
        'meetingPoint': meetingPoint,
        'isActive': isActive,
      };
}

class ActivitySearch {
  ActivitySearch({this.name, this.activityCategoryId, this.isActive});

  final String? name;
  final int? activityCategoryId;
  final bool? isActive;

  Map<String, dynamic> toQuery({required int page, required int pageSize}) {
    final trimmed = name?.trim();

    return {
      'page': page,
      'pageSize': pageSize,
      if (trimmed != null && trimmed.isNotEmpty) 'name': trimmed,
      if (activityCategoryId != null) 'activityCategoryId': activityCategoryId,
      if (isActive != null) 'isActive': isActive,
    };
  }
}

class ActivitySlot {
  ActivitySlot({
    required this.id,
    required this.activityId,
    required this.activityName,
    required this.startTime,
    required this.endTime,
    required this.capacity,
    required this.guideId,
    required this.guideFullName,
    required this.bookedCount,
    required this.availableSpots,
  });

  final int id;
  final int activityId;
  final String activityName;
  final DateTime startTime;
  final DateTime endTime;
  final int capacity;
  final int guideId;
  final String guideFullName;
  final int bookedCount;
  final int availableSpots;

  bool get hasStarted => !startTime.isAfter(DateTime.now());

  factory ActivitySlot.fromJson(Map<String, dynamic> json) => ActivitySlot(
        id: json['id'] as int,
        activityId: json['activityId'] as int,
        activityName: json['activityName'] as String,
        startTime: DateTime.parse(json['startTime'] as String),
        endTime: DateTime.parse(json['endTime'] as String),
        capacity: json['capacity'] as int,
        guideId: json['guideId'] as int,
        guideFullName: json['guideFullName'] as String,
        bookedCount: json['bookedCount'] as int,
        availableSpots: json['availableSpots'] as int,
      );
}

class ActivitySlotRequest {
  ActivitySlotRequest({required this.startTime, required this.capacity, required this.guideId});

  final DateTime startTime;
  final int capacity;
  final int guideId;

  Map<String, dynamic> toJson() => {
        'startTime': startTime.toUtc().toIso8601String(),
        'capacity': capacity,
        'guideId': guideId,
      };
}

class Guide {
  Guide({required this.id, required this.firstName, required this.lastName, required this.phoneNumber});

  final int id;
  final String firstName;
  final String lastName;
  final String? phoneNumber;

  String get fullName => '$firstName $lastName';

  factory Guide.fromJson(Map<String, dynamic> json) => Guide(
        id: json['id'] as int,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        phoneNumber: json['phoneNumber'] as String?,
      );
}
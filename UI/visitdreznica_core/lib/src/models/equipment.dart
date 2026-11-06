class Equipment {
  Equipment({
    required this.id,
    required this.name,
    required this.description,
    required this.equipmentTypeId,
    required this.equipmentTypeName,
    required this.capacity,
    required this.totalQuantity,
    required this.firstHourPrice,
    required this.additionalHourPrice,
    required this.fullDayPrice,
    required this.isActive,
    required this.hasImage,
  });

  final int id;
  final String name;
  final String? description;
  final int equipmentTypeId;
  final String equipmentTypeName;
  final int capacity;
  final int totalQuantity;
  final double firstHourPrice;
  final double additionalHourPrice;
  final double fullDayPrice;
  final bool isActive;
  final bool hasImage;

  factory Equipment.fromJson(Map<String, dynamic> json) => Equipment(
        id: json['id'] as int,
        name: json['name'] as String,
        description: json['description'] as String?,
        equipmentTypeId: json['equipmentTypeId'] as int,
        equipmentTypeName: json['equipmentTypeName'] as String,
        capacity: json['capacity'] as int,
        totalQuantity: json['totalQuantity'] as int,
        firstHourPrice: (json['firstHourPrice'] as num).toDouble(),
        additionalHourPrice: (json['additionalHourPrice'] as num).toDouble(),
        fullDayPrice: (json['fullDayPrice'] as num).toDouble(),
        isActive: json['isActive'] as bool,
        hasImage: json['hasImage'] as bool,
      );
}

class EquipmentUpsertRequest {
  EquipmentUpsertRequest({
    required this.name,
    required this.description,
    required this.equipmentTypeId,
    required this.capacity,
    required this.totalQuantity,
    required this.firstHourPrice,
    required this.additionalHourPrice,
    required this.fullDayPrice,
    required this.isActive,
  });

  final String name;
  final String? description;
  final int equipmentTypeId;
  final int capacity;
  final int totalQuantity;
  final double firstHourPrice;
  final double additionalHourPrice;
  final double fullDayPrice;
  final bool isActive;

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'equipmentTypeId': equipmentTypeId,
        'capacity': capacity,
        'totalQuantity': totalQuantity,
        'firstHourPrice': firstHourPrice,
        'additionalHourPrice': additionalHourPrice,
        'fullDayPrice': fullDayPrice,
        'isActive': isActive,
      };
}

class EquipmentSearch {
  EquipmentSearch({this.name, this.equipmentTypeId, this.isActive});

  final String? name;
  final int? equipmentTypeId;
  final bool? isActive;

  Map<String, dynamic> toQuery({required int page, required int pageSize}) {
    final trimmed = name?.trim();

    return {
      'page': page,
      'pageSize': pageSize,
      if (trimmed != null && trimmed.isNotEmpty) 'name': trimmed,
      if (equipmentTypeId != null) 'equipmentTypeId': equipmentTypeId,
      if (isActive != null) 'isActive': isActive,
    };
  }
}

abstract final class EquipmentPricing {
  static double priceFor(int hours, {required double firstHour, required double additionalHour, required double fullDay}) {
    final hourly = firstHour + additionalHour * (hours - 1);
    return hourly < fullDay ? hourly : fullDay;
  }
}
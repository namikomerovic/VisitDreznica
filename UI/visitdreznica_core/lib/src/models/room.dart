import 'lookup.dart';

class GalleryImage {
  GalleryImage({required this.id, required this.isCover, required this.displayOrder});

  final int id;
  final bool isCover;
  final int displayOrder;

  factory GalleryImage.fromJson(Map<String, dynamic> json) => GalleryImage(
        id: json['id'] as int,
        isCover: json['isCover'] as bool,
        displayOrder: json['displayOrder'] as int,
      );
}

class Room {
  Room({
    required this.id,
    required this.name,
    required this.description,
    required this.roomTypeId,
    required this.roomTypeName,
    required this.capacity,
    required this.areaSquareMeters,
    required this.pricePerNight,
    required this.isActive,
    required this.coverImageId,
    required this.amenities,
    required this.images,
  });

  final int id;
  final String name;
  final String? description;
  final int roomTypeId;
  final String roomTypeName;
  final int capacity;
  final int areaSquareMeters;
  final double pricePerNight;
  final bool isActive;
  final int? coverImageId;
  final List<LookupItem> amenities;
  final List<GalleryImage> images;

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        id: json['id'] as int,
        name: json['name'] as String,
        description: json['description'] as String?,
        roomTypeId: json['roomTypeId'] as int,
        roomTypeName: json['roomTypeName'] as String,
        capacity: json['capacity'] as int,
        areaSquareMeters: json['areaSquareMeters'] as int,
        pricePerNight: (json['pricePerNight'] as num).toDouble(),
        isActive: json['isActive'] as bool,
        coverImageId: json['coverImageId'] as int?,
        amenities: (json['amenities'] as List<dynamic>)
            .map((x) => LookupItem.fromJson(x as Map<String, dynamic>))
            .toList(),
        images: (json['images'] as List<dynamic>)
            .map((x) => GalleryImage.fromJson(x as Map<String, dynamic>))
            .toList()
          ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder)),
      );
}

class RoomUpsertRequest {
  RoomUpsertRequest({
    required this.name,
    required this.description,
    required this.roomTypeId,
    required this.capacity,
    required this.areaSquareMeters,
    required this.pricePerNight,
    required this.isActive,
    required this.amenityIds,
  });

  final String name;
  final String? description;
  final int roomTypeId;
  final int capacity;
  final int areaSquareMeters;
  final double pricePerNight;
  final bool isActive;
  final List<int> amenityIds;

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'roomTypeId': roomTypeId,
        'capacity': capacity,
        'areaSquareMeters': areaSquareMeters,
        'pricePerNight': pricePerNight,
        'isActive': isActive,
        'amenityIds': amenityIds,
      };
}

class RoomSearch {
  RoomSearch({this.name, this.roomTypeId, this.isActive});

  final String? name;
  final int? roomTypeId;
  final bool? isActive;

  Map<String, dynamic> toQuery({required int page, required int pageSize}) {
    final trimmed = name?.trim();

    return {
      'page': page,
      'pageSize': pageSize,
      if (trimmed != null && trimmed.isNotEmpty) 'name': trimmed,
      if (roomTypeId != null) 'roomTypeId': roomTypeId,
      if (isActive != null) 'isActive': isActive,
    };
  }
}
import 'room.dart';

class Place {
  Place({
    required this.id,
    required this.name,
    required this.description,
    required this.placeTypeId,
    required this.placeTypeName,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.distanceKm,
    required this.isActive,
    required this.coverImageId,
    required this.images,
  });

  final int id;
  final String name;
  final String? description;
  final int placeTypeId;
  final String placeTypeName;
  final double latitude;
  final double longitude;
  final String? address;
  final double distanceKm;
  final bool isActive;
  final int? coverImageId;
  final List<GalleryImage> images;

  factory Place.fromJson(Map<String, dynamic> json) => Place(
        id: json['id'] as int,
        name: json['name'] as String,
        description: json['description'] as String?,
        placeTypeId: json['placeTypeId'] as int,
        placeTypeName: json['placeTypeName'] as String,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        address: json['address'] as String?,
        distanceKm: (json['distanceKm'] as num).toDouble(),
        isActive: json['isActive'] as bool,
        coverImageId: json['coverImageId'] as int?,
        images: (json['images'] as List<dynamic>)
            .map((x) => GalleryImage.fromJson(x as Map<String, dynamic>))
            .toList()
          ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder)),
      );
}

class PlaceUpsertRequest {
  PlaceUpsertRequest({
    required this.name,
    required this.description,
    required this.placeTypeId,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.isActive,
  });

  final String name;
  final String? description;
  final int placeTypeId;
  final double latitude;
  final double longitude;
  final String? address;
  final bool isActive;

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'placeTypeId': placeTypeId,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'isActive': isActive,
      };
}

class PlaceSearch {
  PlaceSearch({this.name, this.placeTypeId, this.isActive});

  final String? name;
  final int? placeTypeId;
  final bool? isActive;

  Map<String, dynamic> toQuery({required int page, required int pageSize}) {
    final trimmed = name?.trim();

    return {
      'page': page,
      'pageSize': pageSize,
      if (trimmed != null && trimmed.isNotEmpty) 'name': trimmed,
      if (placeTypeId != null) 'placeTypeId': placeTypeId,
      if (isActive != null) 'isActive': isActive,
    };
  }
}

abstract final class Accommodation {
  static const latitude = 43.5336;
  static const longitude = 17.7008;
}
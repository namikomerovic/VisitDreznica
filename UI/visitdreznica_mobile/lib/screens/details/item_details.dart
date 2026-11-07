import 'package:flutter/material.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

class DetailFact {
  const DetailFact(this.icon, this.text);

  final IconData icon;
  final String text;
}

class ItemDetails {
  ItemDetails({
    required this.type,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageUrls,
    required this.facts,
    this.tags = const [],
    this.priceLabel,
    this.slots = const [],
    this.canReserve = false,
  });

  final ItemType type;
  final int id;
  final String title;
  final String subtitle;
  final String? description;
  final List<String> imageUrls;
  final List<DetailFact> facts;
  final List<String> tags;
  final String? priceLabel;
  final List<ActivitySlot> slots;
  final bool canReserve;
}

class ItemDetailsLoader {
  ItemDetailsLoader(ApiClient api)
      : _rooms = RoomService(api),
        _equipment = EquipmentService(api),
        _activities = ActivityService(api),
        _places = PlaceService(api);

  final RoomService _rooms;
  final EquipmentService _equipment;
  final ActivityService _activities;
  final PlaceService _places;

  Future<ItemDetails> load(ItemType type, int id) => switch (type) {
        ItemType.room => _room(id),
        ItemType.equipment => _equipmentItem(id),
        ItemType.activity => _activity(id),
        ItemType.place => _place(id),
      };

  static List<GalleryImage> _coverFirst(List<GalleryImage> images) =>
      [...images.where((x) => x.isCover), ...images.where((x) => !x.isCover)];

  Future<ItemDetails> _room(int id) async {
    final room = await _rooms.getById(id);

    return ItemDetails(
      type: ItemType.room,
      id: room.id,
      title: room.name,
      subtitle: room.roomTypeName,
      description: room.description,
      imageUrls: [for (final image in _coverFirst(room.images)) _rooms.imageUrl(image.id)],
      facts: [
        DetailFact(Icons.people_outline, 'Do ${room.capacity} ${room.capacity == 1 ? 'osobe' : 'osoba'}'),
        DetailFact(Icons.square_foot, '${room.areaSquareMeters} m²'),
      ],
      tags: [for (final amenity in room.amenities) amenity.name],
      priceLabel: '${Formatters.money(room.pricePerNight)} / noć',
      canReserve: true,
    );
  }

  Future<ItemDetails> _equipmentItem(int id) async {
    final item = await _equipment.getById(id);

    return ItemDetails(
      type: ItemType.equipment,
      id: item.id,
      title: item.name,
      subtitle: item.equipmentTypeName,
      description: item.description,
      imageUrls: [if (item.hasImage) _equipment.imageUrl(item.id)],
      facts: [
        DetailFact(Icons.people_outline, '${item.capacity} ${item.capacity == 1 ? 'osoba' : 'osobe'} po komadu'),
        DetailFact(Icons.inventory_2_outlined, 'Ukupno komada: ${item.totalQuantity}'),
        DetailFact(Icons.timer_outlined, 'Prvi sat: ${Formatters.money(item.firstHourPrice)}'),
        DetailFact(Icons.more_time, 'Svaki sljedeći sat: ${Formatters.money(item.additionalHourPrice)}'),
        DetailFact(Icons.wb_sunny_outlined, 'Cijeli dan: ${Formatters.money(item.fullDayPrice)}'),
      ],
      priceLabel: 'od ${Formatters.money(item.firstHourPrice)} / sat',
      canReserve: true,
    );
  }

  Future<ItemDetails> _activity(int id) async {
    final activity = await _activities.getById(id);
    final slots = await _activities.getSlots(activityId: id, pageSize: 5);
    final meetingPoint = activity.meetingPoint?.trim();

    return ItemDetails(
      type: ItemType.activity,
      id: activity.id,
      title: activity.name,
      subtitle: activity.activityCategoryName,
      description: activity.description,
      imageUrls: [if (activity.hasImage) _activities.imageUrl(activity.id)],
      facts: [
        DetailFact(Icons.schedule, Formatters.duration(activity.durationMinutes)),
        DetailFact(Icons.groups_outlined, 'Najviše ${activity.maxParticipants} učesnika'),
        if (meetingPoint != null && meetingPoint.isNotEmpty) DetailFact(Icons.flag_outlined, 'Okupljanje: $meetingPoint'),
      ],
      priceLabel: '${Formatters.money(activity.pricePerPerson)} / osobi',
      slots: slots.items,
      canReserve: slots.items.any((x) => x.availableSpots > 0),
    );
  }

  Future<ItemDetails> _place(int id) async {
    final place = await _places.getById(id);
    final address = place.address?.trim();

    return ItemDetails(
      type: ItemType.place,
      id: place.id,
      title: place.name,
      subtitle: place.placeTypeName,
      description: place.description,
      imageUrls: [for (final image in _coverFirst(place.images)) _places.imageUrl(image.id)],
      facts: [
        DetailFact(Icons.near_me_outlined, '${Formatters.decimal(place.distanceKm)} km od smještaja'),
        if (address != null && address.isNotEmpty) DetailFact(Icons.map_outlined, address),
      ],
    );
  }
}
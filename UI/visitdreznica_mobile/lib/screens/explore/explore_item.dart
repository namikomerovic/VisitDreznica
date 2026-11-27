import 'package:visitdreznica_core/visitdreznica_core.dart';

class ExploreItem {
  ExploreItem({
    required this.type,
    required this.id,
    required this.title,
    required this.subtitle,
    this.priceLabel,
    this.imageUrl,
    this.extra,
  });

  final ItemType type;
  final int id;
  final String title;
  final String subtitle;
  final String? priceLabel;
  final String? imageUrl;
  final String? extra;
}

class ExploreLoader {
  ExploreLoader(ApiClient api)
      : _rooms = RoomService(api),
        _equipment = EquipmentService(api),
        _activities = ActivityService(api),
        _places = PlaceService(api);

  final RoomService _rooms;
  final EquipmentService _equipment;
  final ActivityService _activities;
  final PlaceService _places;

  Future<List<ExploreItem>> load(ItemType type, String search) async {
    switch (type) {
      case ItemType.room:
        final page = await _rooms.getPage(RoomSearch(name: search), pageSize: 50);
        return [
          for (final r in page.items)
            ExploreItem(
              type: type,
              id: r.id,
              title: r.name,
              subtitle: '${r.roomTypeName} · ${tr.upToPeople(r.capacity)} · ${r.areaSquareMeters} m²',
              priceLabel: tr.pricePerNight(Formatters.money(r.pricePerNight)),
              imageUrl: r.coverImageId == null ? null : _rooms.imageUrl(r.coverImageId!),
            ),
        ];
      case ItemType.equipment:
        final page = await _equipment.getPage(EquipmentSearch(name: search), pageSize: 50);
        return [
          for (final e in page.items)
            ExploreItem(
              type: type,
              id: e.id,
              title: e.name,
              subtitle: '${e.equipmentTypeName} · ${tr.peoplePerPiece(e.capacity)}',
              priceLabel: tr.pricePerHourFrom(Formatters.money(e.firstHourPrice)),
              imageUrl: e.hasImage ? _equipment.imageUrl(e.id) : null,
            ),
        ];
      case ItemType.activity:
        final page = await _activities.getPage(ActivitySearch(name: search), pageSize: 50);
        return [
          for (final a in page.items)
            ExploreItem(
              type: type,
              id: a.id,
              title: a.name,
              subtitle: '${a.activityCategoryName} · ${Formatters.duration(a.durationMinutes)}',
              priceLabel: tr.pricePerPerson(Formatters.money(a.pricePerPerson)),
              imageUrl: a.hasImage ? _activities.imageUrl(a.id) : null,
              extra: a.nextSlotStart == null
                  ? tr.noSlotsNow
                  : tr.nextSlot(Formatters.dateTime(a.nextSlotStart!)),
            ),
        ];
      case ItemType.place:
        final page = await _places.getPage(PlaceSearch(name: search), pageSize: 50);
        return [
          for (final p in page.items)
            ExploreItem(
              type: type,
              id: p.id,
              title: p.name,
              subtitle: '${p.placeTypeName} · ${tr.kmFromAccommodation(Formatters.decimal(p.distanceKm))}',
              imageUrl: p.coverImageId == null ? null : _places.imageUrl(p.coverImageId!),
            ),
        ];
    }
  }
}
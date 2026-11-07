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
              subtitle: '${r.roomTypeName} · do ${r.capacity} ${r.capacity == 1 ? 'osobe' : 'osoba'} · ${r.areaSquareMeters} m²',
              priceLabel: '${Formatters.money(r.pricePerNight)} / noć',
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
              subtitle: '${e.equipmentTypeName} · ${e.capacity} ${e.capacity == 1 ? 'osoba' : 'osobe'} po komadu',
              priceLabel: 'od ${Formatters.money(e.firstHourPrice)} / sat',
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
              priceLabel: '${Formatters.money(a.pricePerPerson)} / osobi',
              imageUrl: a.hasImage ? _activities.imageUrl(a.id) : null,
              extra: a.nextSlotStart == null
                  ? 'Trenutno nema termina'
                  : 'Sljedeći termin: ${Formatters.dateTime(a.nextSlotStart!)}',
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
              subtitle: '${p.placeTypeName} · ${Formatters.decimal(p.distanceKm)} km od smještaja',
              imageUrl: p.coverImageId == null ? null : _places.imageUrl(p.coverImageId!),
            ),
        ];
    }
  }
}
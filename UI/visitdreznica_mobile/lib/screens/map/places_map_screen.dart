import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../utils/maps.dart';
import '../details/item_navigation.dart';

class PlacesMapScreen extends StatefulWidget {
  const PlacesMapScreen({super.key, this.focusPlaceId});

  final int? focusPlaceId;

  @override
  State<PlacesMapScreen> createState() => _PlacesMapScreenState();
}

class _PlacesMapScreenState extends State<PlacesMapScreen> {
  static const _accommodation = LatLng(Accommodation.latitude, Accommodation.longitude);

  final _map = MapController();

  List<Place>? _places;
  Place? _selected;
  String? _error;

  static LatLng _point(Place place) => LatLng(place.latitude, place.longitude);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final page = await PlaceService(context.read<ApiClient>()).getPage(PlaceSearch(), pageSize: 100);
      if (!mounted) return;

      final focus = page.items.where((x) => x.id == widget.focusPlaceId);
      setState(() {
        _places = page.items;
        _selected = focus.isEmpty ? null : focus.first;
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  void _select(Place place) {
    setState(() => _selected = place);
    _map.move(_point(place), math.max(_map.camera.zoom, 13));
  }

  @override
  Widget build(BuildContext context) {
    final places = _places;

    return Scaffold(
      appBar: AppBar(title: const Text('Mapa mjesta')),
      body: places == null
          ? Center(child: _error == null ? const CircularProgressIndicator() : Text(_error!))
          : _buildMap(places),
    );
  }

  Widget _buildMap(List<Place> places) {
    final scheme = Theme.of(context).colorScheme;
    final selected = _selected;

    return Stack(
      children: [
        FlutterMap(
          mapController: _map,
          options: MapOptions(
            initialCenter: selected == null ? _accommodation : _point(selected),
            initialZoom: selected == null ? 12 : 14,
            onTap: (_, _) => setState(() => _selected = null),
          ),
          children: [
            osmTileLayer(),
            MarkerLayer(
              markers: [
                Marker(
                  point: _accommodation,
                  width: 40,
                  height: 40,
                  child: Icon(Icons.house_rounded, color: scheme.primary, size: 34),
                ),
                for (final place in places)
                  Marker(
                    point: _point(place),
                    width: place.id == selected?.id ? 52 : 40,
                    height: place.id == selected?.id ? 52 : 40,
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                      onTap: () => _select(place),
                      child: Icon(
                        Icons.location_on,
                        color: place.id == selected?.id ? scheme.primary : const Color(0xFFDC2626),
                        size: place.id == selected?.id ? 52 : 40,
                      ),
                    ),
                  ),
              ],
            ),
            const SimpleAttributionWidget(source: Text('OpenStreetMap contributors')),
          ],
        ),
        Positioned(
          top: 12,
          right: 12,
          child: FloatingActionButton.small(
            heroTag: 'accommodation',
            tooltip: 'Smještaj',
            onPressed: () => _map.move(_accommodation, 13),
            child: const Icon(Icons.house_outlined),
          ),
        ),
        if (selected != null)
          Positioned(
            left: 12,
            right: 12,
            bottom: 36,
            child: _PlaceCard(place: selected),
          ),
      ],
    );
  }
}

class _PlaceCard extends StatelessWidget {
  const _PlaceCard({required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final address = place.address?.trim();

    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(place.name, style: theme.textTheme.titleMedium),
            const SizedBox(height: 2),
            Text(
              '${place.placeTypeName} · ${Formatters.decimal(place.distanceKm)} km od smještaja',
              style: theme.textTheme.bodySmall,
            ),
            if (address != null && address.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(address, style: theme.textTheme.bodySmall),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => openDirections(context, place.latitude, place.longitude),
                    icon: const Icon(Icons.directions_outlined),
                    label: const Text('Upute'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => openItemDetails(context, ItemType.place, place.id),
                    icon: const Icon(Icons.info_outline),
                    label: const Text('Detalji'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
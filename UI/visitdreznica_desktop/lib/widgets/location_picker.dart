import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({super.key, required this.value, required this.onChanged, this.height = 380});

  final LatLng? value;
  final ValueChanged<LatLng> onChanged;
  final double height;

  @override
  State<LocationPicker> createState() => LocationPickerState();
}

class LocationPickerState extends State<LocationPicker> {
  static const _accommodation = LatLng(Accommodation.latitude, Accommodation.longitude);

  final _mapController = MapController();

  void centerOn(LatLng point) => _mapController.move(point, _mapController.camera.zoom);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: widget.height,
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: widget.value ?? _accommodation,
                initialZoom: 13,
                onTap: (_, point) => widget.onChanged(point),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'ba.visitdreznica.desktop',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _accommodation,
                      width: 36,
                      height: 36,
                      child: Tooltip(
                        message: 'Smještaj',
                        child: Icon(Icons.house_rounded, color: scheme.primary, size: 32),
                      ),
                    ),
                    if (widget.value != null)
                      Marker(
                        point: widget.value!,
                        width: 44,
                        height: 44,
                        alignment: Alignment.topCenter,
                        child: const Icon(Icons.location_on, color: Color(0xFFDC2626), size: 44),
                      ),
                  ],
                ),
              ],
            ),
            Positioned(
              left: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(8)),
                child: const Text('Kliknite na kartu da postavite lokaciju'),
              ),
            ),
            Positioned(
              right: 4,
              bottom: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                color: Colors.white.withValues(alpha: 0.8),
                child: const Text('© OpenStreetMap contributors', style: TextStyle(fontSize: 11)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
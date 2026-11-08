import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';

TileLayer osmTileLayer() => TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'ba.fit.visitdreznica_mobile',
    );

Future<void> openDirections(BuildContext context, double latitude, double longitude) async {
  final messenger = ScaffoldMessenger.of(context);
  final uri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude');

  try {
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened) {
      messenger.showSnackBar(const SnackBar(content: Text('Aplikaciju za mape nije moguće otvoriti.')));
    }
  } catch (_) {
    messenger.showSnackBar(const SnackBar(content: Text('Aplikaciju za mape nije moguće otvoriti.')));
  }
}
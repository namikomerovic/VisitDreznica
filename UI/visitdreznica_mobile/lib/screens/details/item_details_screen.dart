import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../utils/item_type_ui.dart';
import '../../widgets/favorite_button.dart';
import 'image_gallery.dart';
import 'item_details.dart';
import 'item_navigation.dart';
import 'reviews_section.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../utils/maps.dart';
import '../map/places_map_screen.dart';

class ItemDetailsScreen extends StatefulWidget {
  const ItemDetailsScreen({super.key, required this.type, required this.id});

  final ItemType type;
  final int id;

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  late final ItemDetailsLoader _loader;
  late Future<ItemDetails> _future;

  @override
  void initState() {
    super.initState();
    final api = context.read<ApiClient>();
    _loader = ItemDetailsLoader(api);
    _future = _loader.load(widget.type, widget.id);
    _recordView(ContentViewService(api));
  }

  Future<void> _recordView(ContentViewService service) async {
    try {
      await service.record(widget.type, widget.id);
    } catch (_) {
      // Pregled je samo signal za preporuke; ako ne uspije, gost to ne treba primijetiti.
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ItemDetails>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          final error = snapshot.error;

          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      error is ApiException
                          ? error.message
                          : 'Detalje nije moguće učitati.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () => setState(
                        () => _future = _loader.load(widget.type, widget.id),
                      ),
                      child: const Text('Pokušaj ponovo'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return _DetailsView(details: snapshot.data!);
      },
    );
  }
}

class _DetailsView extends StatelessWidget {
  const _DetailsView({required this.details});

  final ItemDetails details;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final type = details.type;
    final description = details.description?.trim();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 260,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: IconButton.filledTonal(
                tooltip: 'Nazad',
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            actions: [
              FavoriteButton(type: type, id: details.id, filled: true),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: ImageGallery(urls: details.imageUrls, type: type),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(type.icon, size: 18, color: type.color),
                      const SizedBox(width: 6),
                      Text(
                        details.subtitle,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: type.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(details.title, style: theme.textTheme.headlineSmall),
                  if (details.priceLabel != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      details.priceLabel!,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final fact in details.facts) _FactChip(fact: fact),
                    ],
                  ),
                  if (description != null && description.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text('Opis', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                    ),
                  ],
                  if (details.tags.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text('Sadržaji', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final tag in details.tags)
                          Chip(
                            label: Text(tag),
                            visualDensity: VisualDensity.compact,
                          ),
                      ],
                    ),
                  ],
                  if (details.latitude != null &&
                      details.longitude != null) ...[
                    const SizedBox(height: 24),
                    Text('Lokacija', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    _LocationPreview(details: details),
                  ],
                  if (type == ItemType.activity) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Nadolazeći termini',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    _SlotsList(slots: details.slots),
                  ],
                  const SizedBox(height: 24),
                  ReviewsSection(type: type, itemId: details.id),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: details.canReserve
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: FilledButton.icon(
                  onPressed: () => startReservation(context, type, details.id),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                  icon: const Icon(Icons.event_available),
                  label: const Text('Rezerviši'),
                ),
              ),
            )
          : null,
    );
  }
}

class _FactChip extends StatelessWidget {
  const _FactChip({required this.fact});

  final DetailFact fact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(fact.icon, size: 18, color: scheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Flexible(child: Text(fact.text)),
        ],
      ),
    );
  }
}

class _SlotsList extends StatelessWidget {
  const _SlotsList({required this.slots});

  final List<ActivitySlot> slots;

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text('Trenutno nema zakazanih termina.'),
      );
    }

    return Column(
      children: [
        for (final slot in slots)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.event_outlined),
            title: Text(Formatters.dateTime(slot.startTime)),
            subtitle: Text('Vodič: ${slot.guideFullName}'),
            trailing: Text(
              slot.availableSpots == 0
                  ? 'Popunjeno'
                  : 'Slobodno: ${slot.availableSpots}',
              style: TextStyle(
                color: slot.availableSpots == 0
                    ? Theme.of(context).colorScheme.error
                    : null,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

class _LocationPreview extends StatelessWidget {
  const _LocationPreview({required this.details});

  final ItemDetails details;

  @override
  Widget build(BuildContext context) {
    final latitude = details.latitude!;
    final longitude = details.longitude!;
    final point = LatLng(latitude, longitude);

    void openMap() => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => PlacesMapScreen(focusPlaceId: details.id)),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 180,
            child: Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    initialCenter: point,
                    initialZoom: 14,
                    interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
                  ),
                  children: [
                    osmTileLayer(),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: point,
                          width: 40,
                          height: 40,
                          alignment: Alignment.topCenter,
                          child: const Icon(Icons.location_on, color: Color(0xFFDC2626), size: 40),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(onTap: openMap),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text('© OpenStreetMap contributors', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: openMap,
                icon: const Icon(Icons.map_outlined),
                label: const Text('Otvori mapu'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton.tonalIcon(
                onPressed: () => openDirections(context, latitude, longitude),
                icon: const Icon(Icons.directions_outlined),
                label: const Text('Upute'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

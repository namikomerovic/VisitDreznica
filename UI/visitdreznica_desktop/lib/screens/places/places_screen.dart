import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../widgets/auth_image.dart';
import '../../widgets/paged_table.dart';
import 'place_form_screen.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  final _tableKey = GlobalKey<PagedTableState<Place>>();
  final _nameController = TextEditingController();
  late final PlaceService _service;
  late final Future<List<LookupItem>> _types;

  Timer? _debounce;
  int? _typeId;
  bool? _isActive;
  int _queryVersion = 0;

  @override
  void initState() {
    super.initState();
    final api = context.read<ApiClient>();
    _service = PlaceService(api);
    _types = LookupService(api, 'PlaceTypes').getAll();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _nameController.dispose();
    super.dispose();
  }

  void _filtersChanged() => setState(() => _queryVersion++);

  Future<void> _openForm({int? id}) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => PlaceFormScreen(placeId: id)),
    );

    if (changed == true) {
      _tableKey.currentState?.reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  SizedBox(
                    width: 260,
                    child: TextField(
                      controller: _nameController,
                      onChanged: (_) {
                        _debounce?.cancel();
                        _debounce = Timer(const Duration(milliseconds: 400), _filtersChanged);
                      },
                      decoration: const InputDecoration(
                        isDense: true,
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Naziv mjesta',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 200,
                    child: FutureBuilder<List<LookupItem>>(
                      future: _types,
                      builder: (context, snapshot) => DropdownButtonFormField<int?>(
                        initialValue: _typeId,
                        decoration: const InputDecoration(labelText: 'Tip mjesta', isDense: true, border: OutlineInputBorder()),
                        items: [
                          const DropdownMenuItem(value: null, child: Text('Svi tipovi')),
                          for (final type in snapshot.data ?? const <LookupItem>[])
                            DropdownMenuItem(value: type.id, child: Text(type.name)),
                        ],
                        onChanged: (value) {
                          _typeId = value;
                          _filtersChanged();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 170,
                    child: DropdownButtonFormField<bool?>(
                      initialValue: _isActive,
                      decoration: const InputDecoration(labelText: 'Status', isDense: true, border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: null, child: Text('Sva')),
                        DropdownMenuItem(value: true, child: Text('Aktivna')),
                        DropdownMenuItem(value: false, child: Text('Neaktivna')),
                      ],
                      onChanged: (value) {
                        _isActive = value;
                        _filtersChanged();
                      },
                    ),
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: () => _openForm(),
                    icon: const Icon(Icons.add),
                    label: const Text('Dodaj mjesto'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: PagedTable<Place>(
                key: _tableKey,
                query: _queryVersion,
                load: (page, pageSize) => _service.getPage(
                  PlaceSearch(name: _nameController.text, placeTypeId: _typeId, isActive: _isActive),
                  page: page,
                  pageSize: pageSize,
                ),
                onRowTap: (place) => _openForm(id: place.id),
                emptyText: 'Nema mjesta za prikaz.',
                columns: [
                  PagedColumn(
                    header: '',
                    flex: 1,
                    cell: (place) => ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: place.coverImageId == null
                          ? Container(
                              width: 64,
                              height: 44,
                              color: scheme.surfaceContainerHighest,
                              child: Icon(Icons.place_outlined, color: scheme.outline),
                            )
                          : AuthImage(url: _service.imageUrl(place.coverImageId!), width: 64, height: 44),
                    ),
                  ),
                  PagedColumn(header: 'Naziv', flex: 4, cell: (place) => Text(place.name)),
                  PagedColumn(header: 'Tip', flex: 2, cell: (place) => Text(place.placeTypeName)),
                  PagedColumn(
                    header: 'Adresa',
                    flex: 3,
                    cell: (place) => Text(place.address ?? '—', overflow: TextOverflow.ellipsis),
                  ),
                  PagedColumn(
                    header: 'Udaljenost',
                    flex: 2,
                    alignEnd: true,
                    cell: (place) => Text('${Formatters.decimal(place.distanceKm)} km'),
                  ),
                  PagedColumn(
                    header: 'Status',
                    flex: 2,
                    alignEnd: true,
                    cell: (place) => Text(
                      place.isActive ? 'Aktivno' : 'Neaktivno',
                      style: TextStyle(color: place.isActive ? const Color(0xFF16A34A) : scheme.outline),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
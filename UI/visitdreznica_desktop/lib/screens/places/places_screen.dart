import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../widgets/filter_bar.dart';
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
              child: FilterBar(
                children: [
                  SizedBox(
                    width: 260,
                    child: TextField(
                      controller: _nameController,
                      onChanged: (_) {
                        _debounce?.cancel();
                        _debounce = Timer(
                          const Duration(milliseconds: 400),
                          _filtersChanged,
                        );
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        prefixIcon: Icon(Icons.search),
                        hintText: tr.placeName,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 200,
                    child: FutureBuilder<List<LookupItem>>(
                      future: _types,
                      builder: (context, snapshot) =>
                          DropdownButtonFormField<int?>(
                            initialValue: _typeId,
                            decoration: InputDecoration(
                              labelText: tr.placeType,
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: null,
                                child: Text(tr.allTypesFilter),
                              ),
                              for (final type
                                  in snapshot.data ?? const <LookupItem>[])
                                DropdownMenuItem(
                                  value: type.id,
                                  child: Text(type.name),
                                ),
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
                      decoration: InputDecoration(
                        labelText: tr.status,
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(value: null, child: Text(tr.allNeuter)),
                        DropdownMenuItem(value: true, child: Text(tr.activeNeuter)),
                        DropdownMenuItem(
                          value: false,
                          child: Text(tr.inactiveNeuter),
                        ),
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
                    label: Text(tr.addPlace),
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
                  PlaceSearch(
                    name: _nameController.text,
                    placeTypeId: _typeId,
                    isActive: _isActive,
                  ),
                  page: page,
                  pageSize: pageSize,
                ),
                onRowTap: (place) => _openForm(id: place.id),
                emptyText: tr.noPlaces,
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
                              child: Icon(
                                Icons.place_outlined,
                                color: scheme.outline,
                              ),
                            )
                          : AuthImage(
                              url: _service.imageUrl(place.coverImageId!),
                              width: 64,
                              height: 44,
                            ),
                    ),
                  ),
                  PagedColumn(
                    header: tr.name,
                    flex: 4,
                    cell: (place) => Text(place.name),
                  ),
                  PagedColumn(
                    header: tr.typeShort,
                    flex: 2,
                    cell: (place) => Text(place.placeTypeName),
                  ),
                  PagedColumn(
                    header: tr.address,
                    flex: 3,
                    cell: (place) => Text(
                      place.address ?? '—',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  PagedColumn(
                    header: tr.distance,
                    flex: 2,
                    alignEnd: true,
                    cell: (place) =>
                        Text('${Formatters.decimal(place.distanceKm)} km'),
                  ),
                  PagedColumn(
                    header: tr.status,
                    flex: 2,
                    alignEnd: true,
                    cell: (place) => Text(
                      place.isActive ? tr.activeNeuter : tr.inactiveNeuter,
                      style: TextStyle(
                        color: place.isActive
                            ? AppColors.success
                            : scheme.outline,
                      ),
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

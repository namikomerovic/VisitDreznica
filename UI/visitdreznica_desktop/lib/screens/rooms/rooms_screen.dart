import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../widgets/paged_table.dart';
import 'room_form_screen.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  final _tableKey = GlobalKey<PagedTableState<Room>>();
  final _nameController = TextEditingController();
  late final RoomService _service;
  late final Future<List<LookupItem>> _roomTypes;

  Timer? _debounce;
  int? _roomTypeId;
  bool? _isActive;
  int _queryVersion = 0;

  @override
  void initState() {
    super.initState();
    final api = context.read<ApiClient>();
    _service = RoomService(api);
    _roomTypes = LookupService(api, 'RoomTypes').getAll();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _nameController.dispose();
    super.dispose();
  }

  void _filtersChanged() => setState(() => _queryVersion++);

  Future<void> _openForm({int? roomId}) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => RoomFormScreen(roomId: roomId)),
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
                        _debounce = Timer(
                          const Duration(milliseconds: 400),
                          _filtersChanged,
                        );
                      },
                      decoration: const InputDecoration(
                        isDense: true,
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Naziv sobe',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 200,
                    child: FutureBuilder<List<LookupItem>>(
                      future: _roomTypes,
                      builder: (context, snapshot) =>
                          DropdownButtonFormField<int?>(
                            initialValue: _roomTypeId,
                            decoration: const InputDecoration(
                              labelText: 'Tip sobe',
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              const DropdownMenuItem(
                                value: null,
                                child: Text('Svi tipovi'),
                              ),
                              for (final type
                                  in snapshot.data ?? const <LookupItem>[])
                                DropdownMenuItem(
                                  value: type.id,
                                  child: Text(type.name),
                                ),
                            ],
                            onChanged: (value) {
                              _roomTypeId = value;
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
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: null, child: Text('Sve')),
                        DropdownMenuItem(value: true, child: Text('Aktivne')),
                        DropdownMenuItem(
                          value: false,
                          child: Text('Neaktivne'),
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
                    label: const Text('Dodaj sobu'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: PagedTable<Room>(
                key: _tableKey,
                query: _queryVersion,
                load: (page, pageSize) => _service.getPage(
                  RoomSearch(
                    name: _nameController.text,
                    roomTypeId: _roomTypeId,
                    isActive: _isActive,
                  ),
                  page: page,
                  pageSize: pageSize,
                ),
                onRowTap: (room) => _openForm(roomId: room.id),
                emptyText: 'Nema soba za prikaz.',
                columns: [
                  PagedColumn(
                    header: '',
                    flex: 1,
                    cell: (room) => ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: room.coverImageId == null
                          ? Container(
                              width: 64,
                              height: 44,
                              color: scheme.surfaceContainerHighest,
                              child: Icon(
                                Icons.bed_outlined,
                                color: scheme.outline,
                              ),
                            )
                          : AuthImage(
                              url: _service.imageUrl(room.coverImageId!),
                              width: 64,
                              height: 44,
                            ),
                    ),
                  ),
                  PagedColumn(
                    header: 'Naziv',
                    flex: 5,
                    cell: (room) => Text(room.name),
                  ),
                  PagedColumn(
                    header: 'Tip',
                    flex: 2,
                    cell: (room) => Text(room.roomTypeName),
                  ),
                  PagedColumn(
                    header: 'Kapacitet',
                    flex: 2,
                    alignEnd: true,
                    cell: (room) => Text('${room.capacity}'),
                  ),
                  PagedColumn(
                    header: 'Površina',
                    flex: 2,
                    alignEnd: true,
                    cell: (room) => Text('${room.areaSquareMeters} m²'),
                  ),
                  PagedColumn(
                    header: 'Cijena / noć',
                    flex: 2,
                    alignEnd: true,
                    cell: (room) => Text(Formatters.money(room.pricePerNight)),
                  ),
                  PagedColumn(
                    header: 'Status',
                    flex: 2,
                    alignEnd: true,
                    cell: (room) => Text(
                      room.isActive ? 'Aktivna' : 'Neaktivna',
                      style: TextStyle(
                        color: room.isActive
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

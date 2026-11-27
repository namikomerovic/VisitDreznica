import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../widgets/filter_bar.dart';
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
                        hintText: tr.roomName,
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
                            decoration: InputDecoration(
                              labelText: tr.roomType,
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
                      decoration: InputDecoration(
                        labelText: tr.status,
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(value: null, child: Text(tr.all)),
                        DropdownMenuItem(value: true, child: Text(tr.activePlural)),
                        DropdownMenuItem(
                          value: false,
                          child: Text(tr.inactivePlural),
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
                    label: Text(tr.addRoom),
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
                emptyText: tr.noRooms,
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
                    header: tr.name,
                    flex: 5,
                    cell: (room) => Text(room.name),
                  ),
                  PagedColumn(
                    header: tr.typeShort,
                    flex: 2,
                    cell: (room) => Text(room.roomTypeName),
                  ),
                  PagedColumn(
                    header: tr.capacity,
                    flex: 2,
                    alignEnd: true,
                    cell: (room) => Text('${room.capacity}'),
                  ),
                  PagedColumn(
                    header: tr.area,
                    flex: 2,
                    alignEnd: true,
                    cell: (room) => Text('${room.areaSquareMeters} m²'),
                  ),
                  PagedColumn(
                    header: tr.pricePerNightHeader,
                    flex: 2,
                    alignEnd: true,
                    cell: (room) => Text(Formatters.money(room.pricePerNight)),
                  ),
                  PagedColumn(
                    header: tr.status,
                    flex: 2,
                    alignEnd: true,
                    cell: (room) => Text(
                      room.isActive ? tr.activeFemale : tr.inactiveFemale,
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

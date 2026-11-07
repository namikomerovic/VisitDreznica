import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../widgets/paged_table.dart';
import 'equipment_form_screen.dart';

class EquipmentScreen extends StatefulWidget {
  const EquipmentScreen({super.key});

  @override
  State<EquipmentScreen> createState() => _EquipmentScreenState();
}

class _EquipmentScreenState extends State<EquipmentScreen> {
  final _tableKey = GlobalKey<PagedTableState<Equipment>>();
  final _nameController = TextEditingController();
  late final EquipmentService _service;
  late final Future<List<LookupItem>> _types;

  Timer? _debounce;
  int? _typeId;
  bool? _isActive;
  int _queryVersion = 0;

  @override
  void initState() {
    super.initState();
    final api = context.read<ApiClient>();
    _service = EquipmentService(api);
    _types = LookupService(api, 'EquipmentTypes').getAll();
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
      MaterialPageRoute(builder: (_) => EquipmentFormScreen(equipmentId: id)),
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
                        hintText: 'Naziv opreme',
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
                        decoration: const InputDecoration(labelText: 'Tip opreme', isDense: true, border: OutlineInputBorder()),
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
                        DropdownMenuItem(value: null, child: Text('Sve')),
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
                    label: const Text('Dodaj opremu'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: PagedTable<Equipment>(
                key: _tableKey,
                query: _queryVersion,
                load: (page, pageSize) => _service.getPage(
                  EquipmentSearch(name: _nameController.text, equipmentTypeId: _typeId, isActive: _isActive),
                  page: page,
                  pageSize: pageSize,
                ),
                onRowTap: (item) => _openForm(id: item.id),
                emptyText: 'Nema opreme za prikaz.',
                columns: [
                  PagedColumn(
                    header: '',
                    flex: 1,
                    cell: (item) => ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: item.hasImage
                          ? AuthImage(url: _service.imageUrl(item.id), width: 64, height: 44)
                          : Container(
                              width: 64,
                              height: 44,
                              color: scheme.surfaceContainerHighest,
                              child: Icon(Icons.kayaking_outlined, color: scheme.outline),
                            ),
                    ),
                  ),
                  PagedColumn(header: 'Naziv', flex: 4, cell: (item) => Text(item.name)),
                  PagedColumn(header: 'Tip', flex: 2, cell: (item) => Text(item.equipmentTypeName)),
                  PagedColumn(
                    header: 'Osoba / kom.',
                    flex: 2,
                    alignEnd: true,
                    cell: (item) => Text('${item.capacity}'),
                  ),
                  PagedColumn(
                    header: 'Komada',
                    flex: 2,
                    alignEnd: true,
                    cell: (item) => Text('${item.totalQuantity}'),
                  ),
                  PagedColumn(
                    header: 'Prvi sat',
                    flex: 2,
                    alignEnd: true,
                    cell: (item) => Text(Formatters.money(item.firstHourPrice)),
                  ),
                  PagedColumn(
                    header: 'Sljedeći sat',
                    flex: 2,
                    alignEnd: true,
                    cell: (item) => Text(Formatters.money(item.additionalHourPrice)),
                  ),
                  PagedColumn(
                    header: 'Cijeli dan',
                    flex: 2,
                    alignEnd: true,
                    cell: (item) => Text(Formatters.money(item.fullDayPrice)),
                  ),
                  PagedColumn(
                    header: 'Status',
                    flex: 2,
                    alignEnd: true,
                    cell: (item) => Text(
                      item.isActive ? 'Aktivna' : 'Neaktivna',
                      style: TextStyle(color: item.isActive ? const Color(0xFF16A34A) : scheme.outline),
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
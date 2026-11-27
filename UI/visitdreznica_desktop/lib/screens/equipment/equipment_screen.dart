import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../widgets/filter_bar.dart';
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
              child: FilterBar(
                children: [
                  SizedBox(
                    width: 260,
                    child: TextField(
                      controller: _nameController,
                      onChanged: (_) {
                        _debounce?.cancel();
                        _debounce = Timer(const Duration(milliseconds: 400), _filtersChanged);
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        prefixIcon: Icon(Icons.search),
                        hintText: tr.equipmentName,
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
                        decoration: InputDecoration(labelText: tr.equipmentType, isDense: true, border: const OutlineInputBorder()),
                        items: [
                          DropdownMenuItem(value: null, child: Text(tr.allTypesFilter)),
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
                      decoration: InputDecoration(labelText: tr.status, isDense: true, border: const OutlineInputBorder()),
                      items: [
                        DropdownMenuItem(value: null, child: Text(tr.all)),
                        DropdownMenuItem(value: true, child: Text(tr.activeFemale)),
                        DropdownMenuItem(value: false, child: Text(tr.inactiveFemale)),
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
                    label: Text(tr.addEquipment),
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
                emptyText: tr.noEquipment,
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
                  PagedColumn(header: tr.name, flex: 4, cell: (item) => Text(item.name)),
                  PagedColumn(header: tr.typeShort, flex: 2, cell: (item) => Text(item.equipmentTypeName)),
                  PagedColumn(
                    header: tr.peoplePerPieceShort,
                    flex: 2,
                    alignEnd: true,
                    cell: (item) => Text('${item.capacity}'),
                  ),
                  PagedColumn(
                    header: tr.pieces,
                    flex: 2,
                    alignEnd: true,
                    cell: (item) => Text('${item.totalQuantity}'),
                  ),
                  PagedColumn(
                    header: tr.firstHour,
                    flex: 2,
                    alignEnd: true,
                    cell: (item) => Text(Formatters.money(item.firstHourPrice)),
                  ),
                  PagedColumn(
                    header: tr.additionalHour,
                    flex: 2,
                    alignEnd: true,
                    cell: (item) => Text(Formatters.money(item.additionalHourPrice)),
                  ),
                  PagedColumn(
                    header: tr.fullDay,
                    flex: 2,
                    alignEnd: true,
                    cell: (item) => Text(Formatters.money(item.fullDayPrice)),
                  ),
                  PagedColumn(
                    header: tr.status,
                    flex: 2,
                    alignEnd: true,
                    cell: (item) => Text(
                      item.isActive ? tr.activeFemale : tr.inactiveFemale,
                      style: TextStyle(color: item.isActive ? AppColors.success : scheme.outline),
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
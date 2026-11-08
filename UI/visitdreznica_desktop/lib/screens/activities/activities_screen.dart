import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../widgets/paged_table.dart';
import 'activity_form_screen.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  final _tableKey = GlobalKey<PagedTableState<Activity>>();
  final _nameController = TextEditingController();
  late final ActivityService _service;
  late final Future<List<LookupItem>> _categories;

  Timer? _debounce;
  int? _categoryId;
  bool? _isActive;
  int _queryVersion = 0;

  @override
  void initState() {
    super.initState();
    final api = context.read<ApiClient>();
    _service = ActivityService(api);
    _categories = LookupService(api, 'ActivityCategories').getAll();
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
      MaterialPageRoute(builder: (_) => ActivityFormScreen(activityId: id)),
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
                        hintText: 'Naziv aktivnosti',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 200,
                    child: FutureBuilder<List<LookupItem>>(
                      future: _categories,
                      builder: (context, snapshot) =>
                          DropdownButtonFormField<int?>(
                            initialValue: _categoryId,
                            decoration: const InputDecoration(
                              labelText: 'Kategorija',
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              const DropdownMenuItem(
                                value: null,
                                child: Text('Sve kategorije'),
                              ),
                              for (final category
                                  in snapshot.data ?? const <LookupItem>[])
                                DropdownMenuItem(
                                  value: category.id,
                                  child: Text(category.name),
                                ),
                            ],
                            onChanged: (value) {
                              _categoryId = value;
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
                    label: const Text('Dodaj aktivnost'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: PagedTable<Activity>(
                key: _tableKey,
                query: _queryVersion,
                load: (page, pageSize) => _service.getPage(
                  ActivitySearch(
                    name: _nameController.text,
                    activityCategoryId: _categoryId,
                    isActive: _isActive,
                  ),
                  page: page,
                  pageSize: pageSize,
                ),
                onRowTap: (item) => _openForm(id: item.id),
                emptyText: 'Nema aktivnosti za prikaz.',
                columns: [
                  PagedColumn(
                    header: '',
                    flex: 1,
                    cell: (item) => ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: item.hasImage
                          ? AuthImage(
                              url: _service.imageUrl(item.id),
                              width: 64,
                              height: 44,
                            )
                          : Container(
                              width: 64,
                              height: 44,
                              color: scheme.surfaceContainerHighest,
                              child: Icon(
                                Icons.hiking_outlined,
                                color: scheme.outline,
                              ),
                            ),
                    ),
                  ),
                  PagedColumn(
                    header: 'Naziv',
                    flex: 5,
                    cell: (item) => Text(item.name),
                  ),
                  PagedColumn(
                    header: 'Kategorija',
                    flex: 2,
                    cell: (item) => Text(item.activityCategoryName),
                  ),
                  PagedColumn(
                    header: 'Trajanje',
                    flex: 2,
                    alignEnd: true,
                    cell: (item) =>
                        Text(Formatters.duration(item.durationMinutes)),
                  ),
                  PagedColumn(
                    header: 'Max osoba',
                    flex: 2,
                    alignEnd: true,
                    cell: (item) => Text('${item.maxParticipants}'),
                  ),
                  PagedColumn(
                    header: 'Cijena / osobi',
                    flex: 2,
                    alignEnd: true,
                    cell: (item) => Text(Formatters.money(item.pricePerPerson)),
                  ),
                  PagedColumn(
                    header: 'Sljedeći termin',
                    flex: 3,
                    alignEnd: true,
                    cell: (item) => Text(
                      item.nextSlotStart == null
                          ? 'Nema termina'
                          : Formatters.dateTime(item.nextSlotStart!),
                      style: item.nextSlotStart == null
                          ? TextStyle(color: scheme.error)
                          : null,
                    ),
                  ),
                  PagedColumn(
                    header: 'Status',
                    flex: 2,
                    alignEnd: true,
                    cell: (item) => Text(
                      item.isActive ? 'Aktivna' : 'Neaktivna',
                      style: TextStyle(
                        color: item.isActive
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

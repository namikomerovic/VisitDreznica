import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../widgets/paged_table.dart';
import 'news_form_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final _tableKey = GlobalKey<PagedTableState<NewsItem>>();
  final _titleController = TextEditingController();
  late final NewsService _service;

  Timer? _debounce;
  int _queryVersion = 0;

  @override
  void initState() {
    super.initState();
    _service = NewsService(context.read<ApiClient>());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _openForm({int? id}) async {
    final changed = await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute(builder: (_) => NewsFormScreen(newsId: id)));

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
                    width: 320,
                    child: TextField(
                      controller: _titleController,
                      onChanged: (_) {
                        _debounce?.cancel();
                        _debounce = Timer(
                          const Duration(milliseconds: 400),
                          () => setState(() => _queryVersion++),
                        );
                      },
                      decoration: const InputDecoration(
                        isDense: true,
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Naslov',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: () => _openForm(),
                    icon: const Icon(Icons.add),
                    label: const Text('Nova novost'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: PagedTable<NewsItem>(
                key: _tableKey,
                query: _queryVersion,
                load: (page, pageSize) => _service.getPage(
                  title: _titleController.text,
                  page: page,
                  pageSize: pageSize,
                ),
                onRowTap: (item) => _openForm(id: item.id),
                emptyText: 'Nema novosti.',
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
                                Icons.newspaper_outlined,
                                color: scheme.outline,
                              ),
                            ),
                    ),
                  ),
                  PagedColumn(
                    header: 'Naslov',
                    flex: 6,
                    cell: (item) =>
                        Text(item.title, overflow: TextOverflow.ellipsis),
                  ),
                  PagedColumn(
                    header: 'Autor',
                    flex: 2,
                    cell: (item) => Text(item.createdByFullName),
                  ),
                  PagedColumn(
                    header: 'Datum objave',
                    flex: 3,
                    alignEnd: true,
                    cell: (item) => Text(Formatters.dateTime(item.publishedAt)),
                  ),
                  PagedColumn(
                    header: 'Status',
                    flex: 2,
                    alignEnd: true,
                    cell: (item) => Text(
                      item.isPublished ? 'Objavljeno' : 'Zakazano',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: item.isPublished
                            ? AppColors.success
                            : AppColors.warning,
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

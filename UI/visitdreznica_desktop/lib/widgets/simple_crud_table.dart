import 'dart:async';

import 'package:flutter/material.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import 'paged_table.dart';

class SimpleCrudTable<T> extends StatefulWidget {
  const SimpleCrudTable({
    super.key,
    required this.searchHint,
    required this.addLabel,
    required this.load,
    required this.columns,
    required this.onAdd,
    required this.onEdit,
  });

  final String searchHint;
  final String addLabel;
  final Future<PageResult<T>> Function(String search, int page, int pageSize) load;
  final List<PagedColumn<T>> columns;
  final Future<bool> Function() onAdd;
  final Future<bool> Function(T item) onEdit;

  @override
  State<SimpleCrudTable<T>> createState() => _SimpleCrudTableState<T>();
}

class _SimpleCrudTableState<T> extends State<SimpleCrudTable<T>> {
  final _tableKey = GlobalKey<PagedTableState<T>>();
  final _searchController = TextEditingController();
  Timer? _debounce;
  int _queryVersion = 0;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handle(Future<bool> Function() action) async {
    if (await action()) {
      _tableKey.currentState?.reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) {
                    _debounce?.cancel();
                    _debounce = Timer(const Duration(milliseconds: 400), () => setState(() => _queryVersion++));
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    prefixIcon: const Icon(Icons.search),
                    hintText: widget.searchHint,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: () => _handle(widget.onAdd),
                icon: const Icon(Icons.add),
                label: Text(widget.addLabel),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: PagedTable<T>(
            key: _tableKey,
            query: _queryVersion,
            load: (page, pageSize) => widget.load(_searchController.text, page, pageSize),
            onRowTap: (item) => _handle(() => widget.onEdit(item)),
            columns: widget.columns,
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import 'error_view.dart';

class PagedColumn<T> {
  const PagedColumn({required this.header, required this.cell, this.flex = 1, this.alignEnd = false});

  final String header;
  final Widget Function(T item) cell;
  final int flex;
  final bool alignEnd;
}

class PagedTable<T> extends StatefulWidget {
  const PagedTable({
    super.key,
    required this.columns,
    required this.load,
    this.onRowTap,
    this.query,
    this.emptyText = 'Nema podataka za prikaz.',
  });

  final List<PagedColumn<T>> columns;
  final Future<PageResult<T>> Function(int page, int pageSize) load;
  final void Function(T item)? onRowTap;
  final Object? query;
  final String emptyText;

  @override
  State<PagedTable<T>> createState() => PagedTableState<T>();
}

class PagedTableState<T> extends State<PagedTable<T>> {
  static const _pageSizes = [10, 20, 50];

  int _page = 1;
  int _pageSize = 20;
  int _requestId = 0;
  bool _loading = false;
  String? _error;
  PageResult<T>? _result;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant PagedTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.query != widget.query) {
      _page = 1;
      _load();
    }
  }

  Future<void> reload() => _load();

  Future<void> _load() async {
    final requestId = ++_requestId;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await widget.load(_page, _pageSize);
      if (!mounted || requestId != _requestId) return;
      setState(() => _result = result);
    } on ApiException catch (e) {
      if (!mounted || requestId != _requestId) return;
      setState(() => _error = e.message);
    } finally {
      if (mounted && requestId == _requestId) {
        setState(() => _loading = false);
      }
    }
  }

  void _goTo(int page) {
    _page = page;
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        SizedBox(height: 3, child: _loading ? const LinearProgressIndicator() : null),
        Container(
          color: theme.colorScheme.surfaceContainerHigh,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              for (final column in widget.columns)
                Expanded(
                  flex: column.flex,
                  child: Align(
                    alignment: column.alignEnd ? Alignment.centerRight : Alignment.centerLeft,
                    child: Text(column.header, style: theme.textTheme.labelLarge),
                  ),
                ),
            ],
          ),
        ),
        Expanded(child: _buildBody(theme)),
        const Divider(height: 1),
        _buildFooter(theme),
      ],
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_error != null) {
      return ErrorView(message: _error!, onRetry: _load);
    }

    final result = _result;

    if (result == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (result.items.isEmpty) {
      return Center(child: Text(widget.emptyText, style: theme.textTheme.bodyLarge));
    }

    return ListView.separated(
      itemCount: result.items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = result.items[index];

        return InkWell(
          onTap: widget.onRowTap == null ? null : () => widget.onRowTap!(item),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                for (final column in widget.columns)
                  Expanded(
                    flex: column.flex,
                    child: Align(
                      alignment: column.alignEnd ? Alignment.centerRight : Alignment.centerLeft,
                      child: column.cell(item),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter(ThemeData theme) {
    final result = _result;
    final total = result?.totalCount ?? 0;
    final first = total == 0 ? 0 : (_page - 1) * _pageSize + 1;
    final last = total == 0 ? 0 : first + (result?.items.length ?? 0) - 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Text('Prikazano $first–$last od $total'),
          const Spacer(),
          const Text('Redova po stranici:'),
          const SizedBox(width: 8),
          DropdownButton<int>(
            value: _pageSize,
            underline: const SizedBox.shrink(),
            items: [for (final size in _pageSizes) DropdownMenuItem(value: size, child: Text('$size'))],
            onChanged: (value) {
              if (value == null) return;
              _pageSize = value;
              _goTo(1);
            },
          ),
          const SizedBox(width: 16),
          IconButton(
            tooltip: 'Prethodna stranica',
            onPressed: result != null && result.hasPrevious && !_loading ? () => _goTo(_page - 1) : null,
            icon: const Icon(Icons.chevron_left),
          ),
          Text('Stranica $_page od ${result?.totalPages ?? 1}'),
          IconButton(
            tooltip: 'Sljedeća stranica',
            onPressed: result != null && result.hasNext && !_loading ? () => _goTo(_page + 1) : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
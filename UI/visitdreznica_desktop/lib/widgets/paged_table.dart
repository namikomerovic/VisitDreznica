import 'package:flutter/material.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import 'error_view.dart';

class PagedColumn<T> {
  const PagedColumn({
    required this.header,
    required this.cell,
    this.flex = 1,
    this.width,
    this.alignEnd = false,
    this.center = false,
    this.hideBelow,
  });

  final String header;
  final Widget Function(T item) cell;

  /// Udio u preostaloj širini (kad [width] nije zadan).
  final int flex;

  /// Fiksna širina kolone – za uske kolone poput broja, iznosa ili statusa.
  final double? width;

  final bool alignEnd;
  final bool center;

  /// Kolona se sakrije kad je tabela uža od ove širine.
  final double? hideBelow;

  Alignment get alignment => center
      ? Alignment.center
      : alignEnd
          ? Alignment.centerRight
          : Alignment.centerLeft;
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
  static const _cellGap = 12.0;

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

  Widget _row(List<PagedColumn<T>> columns, Widget Function(PagedColumn<T> column) build) {
    return Row(
      children: [
        for (final column in columns)
          _sized(
            column,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: _cellGap / 2),
              child: Align(
                alignment: column.alignment,
                child: DefaultTextStyle.merge(
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  child: build(column),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _sized(PagedColumn<T> column, Widget child) =>
      column.width != null ? SizedBox(width: column.width, child: child) : Expanded(flex: column.flex, child: child);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = [
          for (final column in widget.columns)
            if (column.hideBelow == null || constraints.maxWidth >= column.hideBelow!) column,
        ];

        return Column(
          children: [
            SizedBox(height: 3, child: _loading ? const LinearProgressIndicator() : null),
            Container(
              color: theme.colorScheme.surfaceContainerHigh,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: _row(columns, (column) => Text(column.header, style: theme.textTheme.labelLarge)),
            ),
            Expanded(child: _buildBody(theme, columns)),
            const Divider(height: 1),
            _buildFooter(theme),
          ],
        );
      },
    );
  }

  Widget _buildBody(ThemeData theme, List<PagedColumn<T>> columns) {
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
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = result.items[index];

        return InkWell(
          onTap: widget.onRowTap == null ? null : () => widget.onRowTap!(item),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: _row(columns, (column) => column.cell(item)),
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
          Flexible(child: Text('Prikazano $first–$last od $total', overflow: TextOverflow.ellipsis)),
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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../screens/reservations/reservation_details_dialog.dart';

Future<void> showNotificationsPanel(BuildContext context) async {
  final reservationId = await showDialog<int>(
    context: context,
    barrierColor: Colors.black12,
    builder: (_) => const Dialog(
      alignment: Alignment.topRight,
      insetPadding: EdgeInsets.only(top: 64, right: 16, bottom: 16),
      child: SizedBox(width: 440, height: 600, child: NotificationsPanel()),
    ),
  );

  if (!context.mounted) return;
  await context.read<NotificationProvider>().refresh();

  if (reservationId != null && context.mounted) {
    await showReservationDetailsDialog(context, reservationId);
  }
}

class NotificationsPanel extends StatefulWidget {
  const NotificationsPanel({super.key});

  @override
  State<NotificationsPanel> createState() => _NotificationsPanelState();
}

class _NotificationsPanelState extends State<NotificationsPanel> {
  static const _pageSize = 20;

  late final NotificationService _service;

  final List<AppNotification> _items = [];
  int _page = 0;
  bool _hasMore = true;
  bool _loading = false;
  bool _onlyUnread = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _service = NotificationService(context.read<ApiClient>());
    _loadMore();
  }

  Future<void> _reload() async {
    setState(() {
      _items.clear();
      _page = 0;
      _hasMore = true;
      _error = null;
    });
    await _loadMore();
  }

  Future<void> _loadMore() async {
    if (_loading || !_hasMore) return;

    setState(() => _loading = true);

    try {
      final result = await _service.getPage(
        page: _page + 1,
        pageSize: _pageSize,
        onlyUnread: _onlyUnread,
      );

      if (!mounted) return;

      setState(() {
        _items.addAll(result.items);
        _page = result.page;
        _hasMore = result.hasNext;
        _error = null;
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _run(Future<void> Function() action) async {
    try {
      await action();
      if (mounted) await context.read<NotificationProvider>().refresh();
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  Future<void> _open(AppNotification item) async {
    if (!item.isRead) {
      await _run(() async {
        await _service.markAsRead(item.id);

        if (!mounted) return;
        setState(() {
          final index = _items.indexWhere((x) => x.id == item.id);
          if (index >= 0) {
            _onlyUnread
                ? _items.removeAt(index)
                : _items[index] = item.markedAsRead();
          }
        });
      });
    }

    if (item.reservationId != null && mounted) {
      Navigator.pop(context, item.reservationId);
    }
  }

  Future<void> _markAll() => _run(() async {
    await _service.markAllAsRead();

    if (!mounted) return;
    setState(() {
      if (_onlyUnread) {
        _items.clear();
        _hasMore = false;
      } else {
        for (var i = 0; i < _items.length; i++) {
          _items[i] = _items[i].markedAsRead();
        }
      }
    });
  });

  Future<void> _delete(AppNotification item) => _run(() async {
    await _service.delete(item.id);

    if (!mounted) return;
    setState(() => _items.removeWhere((x) => x.id == item.id));
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
          child: Row(
            children: [
              Text('Obavijesti', style: theme.textTheme.titleLarge),
              const Spacer(),
              TextButton.icon(
                onPressed: _items.any((x) => !x.isRead) ? _markAll : null,
                icon: const Icon(Icons.done_all, size: 18),
                label: const Text('Označi sve pročitano'),
              ),
              IconButton(
                tooltip: 'Zatvori',
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
        CheckboxListTile(
          dense: true,
          controlAffinity: ListTileControlAffinity.leading,
          title: const Text('Samo nepročitane'),
          value: _onlyUnread,
          onChanged: (value) {
            _onlyUnread = value ?? false;
            _reload();
          },
        ),
        const Divider(height: 1),
        Expanded(child: _buildList(theme)),
      ],
    );
  }

  Widget _buildList(ThemeData theme) {
    if (_error != null && _items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _reload,
              child: const Text('Pokušaj ponovo'),
            ),
          ],
        ),
      );
    }

    if (_items.isEmpty && _loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.notifications_none,
              size: 48,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 8),
            Text(
              _onlyUnread
                  ? 'Nema nepročitanih obavijesti.'
                  : 'Nema obavijesti.',
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: _items.length + (_hasMore ? 1 : 0),
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        if (index == _items.length) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: _loading
                  ? const CircularProgressIndicator()
                  : OutlinedButton(
                      onPressed: _loadMore,
                      child: const Text('Učitaj još'),
                    ),
            ),
          );
        }

        return _NotificationTile(
          item: _items[index],
          onTap: () => _open(_items[index]),
          onDelete: () => _delete(_items[index]),
        );
      },
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  final AppNotification item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  static IconData _iconFor(NotificationType type) => switch (type) {
    NotificationType.payment => Icons.payments_outlined,
    NotificationType.reservation => Icons.event_note_outlined,
    NotificationType.system => Icons.info_outline,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Material(
      color: item.isRead
          ? Colors.transparent
          : scheme.primaryContainer.withValues(alpha: 0.35),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(_iconFor(item.type), color: scheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: item.isRead
                            ? FontWeight.normal
                            : FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(item.message, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 4),
                    Text(
                      Formatters.relative(item.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (!item.isRead)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: CircleAvatar(
                    radius: 4,
                    backgroundColor: scheme.primary,
                  ),
                ),
              IconButton(
                tooltip: 'Obriši',
                iconSize: 18,
                onPressed: onDelete,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

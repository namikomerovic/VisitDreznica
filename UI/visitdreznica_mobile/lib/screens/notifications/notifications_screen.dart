import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../reservations/reservation_details_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const _pageSize = 20;

  late final NotificationService _service;
  late final NotificationProvider _provider;

  List<AppNotification> _items = [];
  PageResult<AppNotification>? _lastPage;
  bool _loading = true;
  bool _loadingMore = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _service = NotificationService(context.read<ApiClient>());
    _provider = context.read<NotificationProvider>();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final page = await _service.getPage(pageSize: _pageSize);
      if (!mounted) return;
      setState(() {
        _items = page.items;
        _lastPage = page;
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadMore() async {
    final last = _lastPage;
    if (last == null || !last.hasNext || _loadingMore) return;

    setState(() => _loadingMore = true);

    try {
      final page = await _service.getPage(page: last.page + 1, pageSize: _pageSize);
      if (!mounted) return;
      setState(() {
        _items = [..._items, ...page.items];
        _lastPage = page;
      });
    } on ApiException catch (e) {
      if (mounted) _showMessage(e.message);
    } finally {
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  void _showMessage(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  void _replace(AppNotification updated) {
    setState(() => _items = [for (final x in _items) x.id == updated.id ? updated : x]);
  }

  Future<void> _open(AppNotification notification) async {
    if (!notification.isRead) {
      _replace(notification.markedAsRead());
      try {
        await _service.markAsRead(notification.id);
        _provider.refresh();
      } on ApiException {
        // Ako označavanje ne uspije, obavijest će se sljedeći put opet prikazati kao nova.
      }
    }

    final reservationId = notification.reservationId;
    if (reservationId == null || !mounted) return;

    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => ReservationDetailsScreen(reservationId: reservationId)),
    );
  }

  Future<void> _markAllAsRead() async {
    try {
      await _service.markAllAsRead();
      if (!mounted) return;
      setState(() => _items = [for (final x in _items) x.markedAsRead()]);
      _provider.refresh();
    } on ApiException catch (e) {
      if (mounted) _showMessage(e.message);
    }
  }

  Future<void> _delete(AppNotification notification) async {
    final index = _items.indexOf(notification);
    setState(() => _items = [..._items]..remove(notification));

    try {
      await _service.delete(notification.id);
      _provider.refresh();
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _items = [..._items]..insert(index, notification));
      _showMessage(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasUnread = _items.any((x) => !x.isRead);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Obavijesti'),
        actions: [
          if (hasUnread)
            IconButton(
              tooltip: 'Označi sve kao pročitano',
              onPressed: _markAllAsRead,
              icon: const Icon(Icons.done_all),
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final theme = Theme.of(context);

    if (_loading && _items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              OutlinedButton(onPressed: _load, child: const Text('Pokušaj ponovo')),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: _items.isEmpty
          ? ListView(
              children: [
                const SizedBox(height: 120),
                Icon(Icons.notifications_none, size: 56, color: theme.colorScheme.outline),
                const SizedBox(height: 12),
                const Center(child: Text('Nemate obavijesti.')),
              ],
            )
          : ListView(
              children: [
                for (final notification in _items)
                  Dismissible(
                    key: ValueKey(notification.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: theme.colorScheme.error,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 24),
                      child: Icon(Icons.delete_outline, color: theme.colorScheme.onError),
                    ),
                    onDismissed: (_) => _delete(notification),
                    child: _NotificationTile(notification: notification, onTap: () => _open(notification)),
                  ),
                if (_lastPage?.hasNext ?? false)
                  Center(
                    child: TextButton(
                      onPressed: _loadingMore ? null : _loadMore,
                      child: Text(_loadingMore ? 'Učitavanje...' : 'Prikaži starije'),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification, required this.onTap});

  final AppNotification notification;
  final VoidCallback onTap;

  IconData get _icon => switch (notification.type) {
        NotificationType.reservation => Icons.event_note_outlined,
        NotificationType.payment => Icons.credit_card,
        NotificationType.system => Icons.info_outline,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unread = !notification.isRead;

    return Material(
      color: unread ? theme.colorScheme.primaryContainer.withValues(alpha: 0.35) : Colors.transparent,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
          child: Icon(_icon, color: theme.colorScheme.primary),
        ),
        title: Text(
          notification.title,
          style: TextStyle(fontWeight: unread ? FontWeight.w700 : FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(notification.message),
            const SizedBox(height: 4),
            Text(Formatters.relative(notification.createdAt), style: theme.textTheme.bodySmall),
          ],
        ),
        trailing: unread
            ? Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: theme.colorScheme.primary, shape: BoxShape.circle),
              )
            : null,
        isThreeLine: true,
      ),
    );
  }
}
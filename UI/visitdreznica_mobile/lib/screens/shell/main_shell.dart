import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../profile/profile_tab.dart';
import '../explore/explore_tab.dart';
import '../home/home_tab.dart';
import '../../providers/favorites_provider.dart';
import '../favorites/favorites_tab.dart';
import '../reservations/reservations_tab.dart';
import '../notifications/notifications_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  final _exploreType = ValueNotifier<ItemType>(ItemType.room);
  late final NotificationProvider _notifications;
  final _reservationsKey = GlobalKey<ReservationsTabState>();
  // Čuva stanje tabova kad se pri okretanju ekrana promijeni raspored (traka ↔ bočna navigacija).
  final _stackKey = GlobalKey();

  List<String> get _titles => [
        tr.appName,
        tr.tabExplore,
        tr.titleMyReservations,
        tr.tabFavorites,
        tr.tabProfile,
      ];

  void _select(int index) {
    setState(() => _index = index);
    if (index == 2) _reservationsKey.currentState?.reload();
  }

  List<(IconData, IconData, String)> get _destinations => [
        (Icons.home_outlined, Icons.home, tr.tabHome),
        (Icons.explore_outlined, Icons.explore, tr.tabExplore),
        (Icons.event_note_outlined, Icons.event_note, tr.tabReservations),
        (Icons.favorite_outline, Icons.favorite, tr.tabFavorites),
        (Icons.person_outline, Icons.person, tr.tabProfile),
      ];

  @override
  void initState() {
    super.initState();
    _notifications = context.read<NotificationProvider>()..start();
    context.read<FavoritesProvider>().load();
  }

  @override
  void dispose() {
    _notifications.stop();
    _exploreType.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unread = context.watch<NotificationProvider>().unreadCount;
    // Na tabletu i u ležećem položaju: bočna navigacija umjesto donje trake.
    final useRail = MediaQuery.sizeOf(context).width >= Breakpoints.compact;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          children: [
            const AppLogo(size: 32),
            const SizedBox(width: 10),
            Flexible(
              child: Text(_titles[_index], overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: tr.notifications,
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const NotificationsScreen(),
                ),
              );
              _notifications.refresh();
              if (_index == 2) _reservationsKey.currentState?.reload();
            },
            icon: Badge(
              isLabelVisible: unread > 0,
              label: Text(unread > 99 ? '99+' : '$unread'),
              child: const Icon(Icons.notifications_outlined),
            ),
          ),
        ],
      ),
      body: _wrapWithRail(useRail, IndexedStack(
        key: _stackKey,
        index: _index,
        children: [
          HomeTab(
            onOpenCategory: (type) {
              _exploreType.value = type;
              setState(() => _index = 1);
            },
            onOpenExplore: () => setState(() => _index = 1),
          ),
          ExploreTab(selectedType: _exploreType),
          ReservationsTab(
            key: _reservationsKey,
            onExplore: () => setState(() => _index = 1),
          ),
          const FavoritesTab(),
          const ProfileTab(),
        ],
      )),
      bottomNavigationBar: useRail
          ? null
          : NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: _select,
              destinations: [
                for (final (icon, selectedIcon, label) in _destinations)
                  NavigationDestination(icon: Icon(icon), selectedIcon: Icon(selectedIcon), label: label),
              ],
            ),
    );
  }

  Widget _wrapWithRail(bool useRail, Widget body) {
    if (!useRail) return body;

    return Row(
      children: [
        NavigationRail(
          selectedIndex: _index,
          onDestinationSelected: _select,
          labelType: MediaQuery.sizeOf(context).height < 480
              ? NavigationRailLabelType.none
              : NavigationRailLabelType.all,
          destinations: [
            for (final (icon, selectedIcon, label) in _destinations)
              NavigationRailDestination(icon: Icon(icon), selectedIcon: Icon(selectedIcon), label: Text(label)),
          ],
        ),
        const VerticalDivider(width: 1),
        Expanded(child: body),
      ],
    );
  }
}

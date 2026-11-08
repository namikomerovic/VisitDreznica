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

  static const _titles = [
    'Visit Drežnica',
    'Istraži',
    'Moje rezervacije',
    'Favoriti',
    'Profil',
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

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_index]),
        actions: [
          IconButton(
            tooltip: 'Obavijesti',
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
      body: IndexedStack(
        index: _index,
        children: [
          HomeTab(
            onOpenCategory: (type) {
              _exploreType.value = type;
              setState(() => _index = 1);
            },
          ),
          ExploreTab(selectedType: _exploreType),
          ReservationsTab(
            key: _reservationsKey,
            onExplore: () => setState(() => _index = 1),
          ),
          const FavoritesTab(),
          const ProfileTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) {
          setState(() => _index = index);
          if (index == 2) _reservationsKey.currentState?.reload();
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Početna',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Istraži',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note),
            label: 'Rezervacije',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoriti',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

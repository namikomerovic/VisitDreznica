import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../widgets/coming_soon.dart';
import '../profile/profile_tab.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  late final NotificationProvider _notifications;

  static const _titles = ['Visit Drežnica', 'Istraži', 'Moje rezervacije', 'Favoriti', 'Profil'];

  @override
  void initState() {
    super.initState();
    _notifications = context.read<NotificationProvider>()..start();
  }

  @override
  void dispose() {
    _notifications.stop();
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
            onPressed: () => ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Obavijesti dolaze uskoro.'))),
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
        children: const [
          ComingSoon(title: 'Početna', icon: Icons.home_outlined),
          ComingSoon(title: 'Istraži', icon: Icons.explore_outlined),
          ComingSoon(title: 'Rezervacije', icon: Icons.event_note_outlined),
          ComingSoon(title: 'Favoriti', icon: Icons.favorite_outline),
          ProfileTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Početna'),
          NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'Istraži'),
          NavigationDestination(
              icon: Icon(Icons.event_note_outlined), selectedIcon: Icon(Icons.event_note), label: 'Rezervacije'),
          NavigationDestination(icon: Icon(Icons.favorite_outline), selectedIcon: Icon(Icons.favorite), label: 'Favoriti'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
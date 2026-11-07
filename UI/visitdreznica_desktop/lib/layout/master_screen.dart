import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../screens/reservations/reservations_screen.dart';
import '../widgets/notifications_panel.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/rooms/rooms_screen.dart';
import '../screens/equipment/equipment_screen.dart';
import '../screens/activities/activities_screen.dart';
import '../screens/places/places_screen.dart';
import '../screens/news/news_screen.dart';
import '../screens/lookups/lookups_screen.dart';
import '../screens/users/users_screen.dart';
import '../screens/recommendations/recommendations_screen.dart';
import '../screens/reports/reports_screen.dart';
import '../screens/reviews/reviews_screen.dart';

class _Section {
  const _Section(this.label, this.icon, this.selectedIcon, this.builder);

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final WidgetBuilder builder;
}

final _sections = <_Section>[
  _Section(
    'Dashboard',
    Icons.dashboard_outlined,
    Icons.dashboard,
    (_) => const DashboardScreen(),
  ),
  _Section(
    'Rezervacije',
    Icons.event_note_outlined,
    Icons.event_note,
    (_) => const ReservationsScreen(),
  ),
  _Section('Sobe', Icons.bed_outlined, Icons.bed, (_) => const RoomsScreen()),
  _Section(
    'Oprema',
    Icons.kayaking_outlined,
    Icons.kayaking,
    (_) => const EquipmentScreen(),
  ),
  _Section(
    'Aktivnosti',
    Icons.hiking_outlined,
    Icons.hiking,
    (_) => const ActivitiesScreen(),
  ),
  _Section(
    'Mjesta',
    Icons.place_outlined,
    Icons.place,
    (_) => const PlacesScreen(),
  ),
  _Section(
    'Novosti',
    Icons.newspaper_outlined,
    Icons.newspaper,
    (_) => const NewsScreen(),
  ),
  _Section(
    'Recenzije',
    Icons.reviews_outlined,
    Icons.reviews,
    (_) => const ReviewsScreen(),
  ),
  _Section(
    'Korisnici',
    Icons.people_outline,
    Icons.people,
    (_) => const UsersScreen(),
  ),
  _Section(
    'Šifarnici',
    Icons.list_alt_outlined,
    Icons.list_alt,
    (_) => const LookupsScreen(),
  ),
  _Section(
    'Izvještaji',
    Icons.picture_as_pdf_outlined,
    Icons.picture_as_pdf,
    (_) => const ReportsScreen(),
  ),
  _Section(
    'Preporuke (ML)',
    Icons.auto_awesome_outlined,
    Icons.auto_awesome,
    (_) => const RecommendationsScreen(),
  ),
];

class MasterScreen extends StatefulWidget {
  const MasterScreen({super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  int _selectedIndex = 0;
  late final NotificationProvider _notifications;

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

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Odjava'),
        content: const Text('Da li se želite odjaviti?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Odustani'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Odjavi se'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await context.read<AuthProvider>().logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final section = _sections[_selectedIndex];

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 248,
            color: scheme.surfaceContainerLow,
            child: Column(
              children: [
                SizedBox(
                  height: 64,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const AppLogo(size: 40),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Visit Drežnica',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _sections.length,
                    itemBuilder: (context, index) {
                      final item = _sections[index];
                      final selected = index == _selectedIndex;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        child: ListTile(
                          leading: Icon(
                            selected ? item.selectedIcon : item.icon,
                          ),
                          title: Text(item.label),
                          selected: selected,
                          selectedTileColor: scheme.secondaryContainer,
                          selectedColor: scheme.onSecondaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onTap: () => setState(() => _selectedIndex = index),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Column(
              children: [
                _TopBar(title: section.label, onLogout: _confirmLogout),
                const Divider(height: 1),
                Expanded(
                  child: KeyedSubtree(
                    key: ValueKey(_selectedIndex),
                    child: section.builder(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.onLogout});

  final String title;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final unread = context.watch<NotificationProvider>().unreadCount;

    return SizedBox(
      height: 64,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const Spacer(),
            IconButton(
              tooltip: 'Obavijesti',
              onPressed: () => showNotificationsPanel(context),
              icon: Badge(
                isLabelVisible: unread > 0,
                label: Text(unread > 99 ? '99+' : '$unread'),
                child: const Icon(Icons.notifications_outlined),
              ),
            ),
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 16,
              child: Text(
                auth.session?.firstName.characters.first.toUpperCase() ?? '?',
              ),
            ),
            const SizedBox(width: 8),
            Text(auth.session?.fullName ?? ''),
            const SizedBox(width: 8),
            IconButton(
              tooltip: 'Odjava',
              onPressed: onLogout,
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }
}

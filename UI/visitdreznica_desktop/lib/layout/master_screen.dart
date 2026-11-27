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
    final section = _sections[_selectedIndex];
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 248,
            color: dark ? const Color(0xFF0C1410) : AppColors.forest,
            child: Column(
              children: [
                SizedBox(
                  height: 72,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      children: [
                        const AppLogo(size: 40),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Visit Drežnica',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontSize: 19,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemCount: _sections.length,
                    itemBuilder: (context, index) {
                      final item = _sections[index];
                      return _SidebarTile(
                        icon: index == _selectedIndex ? item.selectedIcon : item.icon,
                        label: item.label,
                        selected: index == _selectedIndex,
                        onTap: () => setState(() => _selectedIndex = index),
                      );
                    },
                  ),
                ),
                const Divider(height: 1, color: Colors.white24, indent: 16, endIndent: 16),
                const SizedBox(height: 6),
                const _ThemeTile(),
                _SidebarTile(
                  icon: Icons.logout,
                  label: 'Odjava',
                  selected: false,
                  onTap: _confirmLogout,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                _TopBar(title: section.label),
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

class _SidebarTile extends StatelessWidget {
  const _SidebarTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.white : Colors.white70;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Material(
        color: selected ? Colors.white.withValues(alpha: 0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          hoverColor: Colors.white.withValues(alpha: 0.06),
          onTap: onTap,
          child: SizedBox(
            height: 46,
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 22,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.nightTerracotta : Colors.transparent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 11),
                Icon(icon, color: color, size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontSize: 15,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  const _ThemeTile();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ThemeController>();

    return PopupMenuButton<ThemeMode>(
      tooltip: 'Izgled',
      offset: const Offset(240, -120),
      onSelected: controller.setMode,
      itemBuilder: (context) => [
        for (final (mode, label) in [
          (ThemeMode.system, 'Prati sistem'),
          (ThemeMode.light, 'Svijetla tema'),
          (ThemeMode.dark, 'Tamna tema'),
        ])
          CheckedPopupMenuItem(
            value: mode,
            checked: mode == controller.mode,
            child: Text(label),
          ),
      ],
      child: IgnorePointer(
        child: _SidebarTile(
          icon: switch (controller.mode) {
            ThemeMode.system => Icons.brightness_auto_outlined,
            ThemeMode.light => Icons.light_mode_outlined,
            ThemeMode.dark => Icons.dark_mode_outlined,
          },
          label: 'Izgled',
          selected: false,
          onTap: () {},
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthProvider>();
    final unread = context.watch<NotificationProvider>().unreadCount;

    return SizedBox(
      height: 72,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Administracija  /  $title',
                  style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 2),
                Text(title, style: theme.textTheme.headlineSmall?.copyWith(fontSize: 24)),
              ],
            ),
            const Spacer(),
            IconButton(
              tooltip: 'Obavijesti',
              onPressed: () => showNotificationsPanel(context),
              icon: Badge(
                isLabelVisible: unread > 0,
                backgroundColor: AppColors.terracotta,
                label: Text(unread > 99 ? '99+' : '$unread'),
                child: const Icon(Icons.notifications_outlined),
              ),
            ),
            const SizedBox(width: 16),
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.terracottaSoft,
              foregroundColor: AppColors.terracotta,
              child: Text(
                auth.session?.firstName.characters.first.toUpperCase() ?? '?',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(auth.session?.fullName ?? '', style: theme.textTheme.labelLarge),
                Text('Administrator', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

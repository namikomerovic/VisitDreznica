import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../screens/activities/activities_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/equipment/equipment_screen.dart';
import '../screens/lookups/lookups_screen.dart';
import '../screens/news/news_screen.dart';
import '../screens/places/places_screen.dart';
import '../screens/recommendations/recommendations_screen.dart';
import '../screens/reports/reports_screen.dart';
import '../screens/reservations/reservations_screen.dart';
import '../screens/reviews/reviews_screen.dart';
import '../screens/rooms/rooms_screen.dart';
import '../screens/users/users_screen.dart';
import '../widgets/notifications_panel.dart';
import 'admin_section.dart';

/// Širine prozora na kojima se sidebar mijenja.
const _fullSidebarWidth = 1100.0;
const _railWidth = 720.0;

class MasterScreen extends StatefulWidget {
  const MasterScreen({super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AdminSection _section = AdminSection.dashboard;
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

  void _open(AdminSection section) {
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }
    setState(() => _section = section);
  }

  Widget _buildSection() => switch (_section) {
        AdminSection.dashboard => DashboardScreen(onOpen: _open),
        AdminSection.reservations => const ReservationsScreen(),
        AdminSection.rooms => const RoomsScreen(),
        AdminSection.equipment => const EquipmentScreen(),
        AdminSection.activities => const ActivitiesScreen(),
        AdminSection.places => const PlacesScreen(),
        AdminSection.news => const NewsScreen(),
        AdminSection.reviews => const ReviewsScreen(),
        AdminSection.users => const UsersScreen(),
        AdminSection.lookups => const LookupsScreen(),
        AdminSection.reports => const ReportsScreen(),
        AdminSection.recommendations => const RecommendationsScreen(),
      };

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr.logout),
        content: Text(tr.logoutQuestion),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(tr.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(tr.logoutAction),
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
    final width = MediaQuery.sizeOf(context).width;
    final showDrawer = width < _railWidth;
    final collapsed = !showDrawer && width < _fullSidebarWidth;

    final sidebar = _Sidebar(
      selected: _section,
      collapsed: collapsed,
      onSelect: _open,
      onLogout: _confirmLogout,
    );

    return Scaffold(
      key: _scaffoldKey,
      drawer: showDrawer
          ? Drawer(
              width: 260,
              shape: const RoundedRectangleBorder(),
              child: _Sidebar(
                selected: _section,
                collapsed: false,
                onSelect: _open,
                onLogout: _confirmLogout,
              ),
            )
          : null,
      body: Row(
        children: [
          if (!showDrawer) sidebar,
          Expanded(
            child: Column(
              children: [
                _TopBar(
                  title: _section.label,
                  onMenu: showDrawer ? () => _scaffoldKey.currentState?.openDrawer() : null,
                ),
                const Divider(height: 1),
                Expanded(
                  child: KeyedSubtree(
                    key: ValueKey(_section),
                    child: _buildSection(),
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

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.selected,
    required this.collapsed,
    required this.onSelect,
    required this.onLogout,
  });

  final AdminSection selected;
  final bool collapsed;
  final ValueChanged<AdminSection> onSelect;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: collapsed ? 76 : 248,
      color: dark ? const Color(0xFF0C1410) : AppColors.forest,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 72,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: collapsed ? 0 : 18),
                child: Row(
                  mainAxisAlignment: collapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
                  children: [
                    const AppLogo(size: 40),
                    if (!collapsed) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          tr.appName,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontSize: 19,
                              ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 4),
                children: [
                  for (final section in AdminSection.values)
                    _SidebarTile(
                      icon: section == selected ? section.selectedIcon : section.icon,
                      label: section.label,
                      selected: section == selected,
                      collapsed: collapsed,
                      onTap: () => onSelect(section),
                    ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.white24, indent: 16, endIndent: 16),
            const SizedBox(height: 6),
            _LanguageTile(collapsed: collapsed),
            _ThemeTile(collapsed: collapsed),
            _SidebarTile(
              icon: Icons.logout,
              label: tr.logout,
              selected: false,
              collapsed: collapsed,
              onTap: onLogout,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class _SidebarTile extends StatelessWidget {
  const _SidebarTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.collapsed,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool collapsed;
  final VoidCallback? onTap;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.white : Colors.white70;

    final tile = Padding(
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
                if (collapsed)
                  Expanded(child: Icon(icon, color: color, size: 22))
                else ...[
                  const SizedBox(width: 11),
                  Icon(icon, color: color, size: 22),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: color,
                        fontSize: 15,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                  if (trailing != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Text(trailing!, style: const TextStyle(color: Colors.white54, fontSize: 13)),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    return collapsed ? Tooltip(message: label, waitDuration: const Duration(milliseconds: 300), child: tile) : tile;
  }
}

class _ThemeTile extends StatelessWidget {
  const _ThemeTile({required this.collapsed});

  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ThemeController>();

    return PopupMenuButton<ThemeMode>(
      tooltip: tr.appearance,
      offset: Offset(collapsed ? 70 : 240, -120),
      onSelected: controller.setMode,
      itemBuilder: (context) => [
        for (final (mode, label) in [
          (ThemeMode.system, tr.themeFollowSystem),
          (ThemeMode.light, tr.themeLightLong),
          (ThemeMode.dark, tr.themeDarkLong),
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
          label: tr.appearance,
          selected: false,
          collapsed: collapsed,
          onTap: () {},
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({required this.collapsed});

  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LocaleController>();
    final current = controller.locale.languageCode;

    return PopupMenuButton<String>(
      tooltip: tr.language,
      offset: Offset(collapsed ? 70 : 240, -80),
      onSelected: (code) => controller.setLocale(Locale(code)),
      itemBuilder: (context) => [
        for (final (code, label) in [('bs', tr.languageBosnian), ('en', tr.languageEnglish)])
          CheckedPopupMenuItem(value: code, checked: code == current, child: Text(label)),
      ],
      child: IgnorePointer(
        child: _SidebarTile(
          icon: Icons.translate,
          label: tr.language,
          trailing: current.toUpperCase(),
          selected: false,
          collapsed: collapsed,
          onTap: () {},
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, this.onMenu});

  final String title;
  final VoidCallback? onMenu;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthProvider>();
    final unread = context.watch<NotificationProvider>().unreadCount;
    final showName = MediaQuery.sizeOf(context).width >= 900;

    return SizedBox(
      height: 72,
      child: Padding(
        padding: EdgeInsets.only(left: onMenu == null ? 28 : 12, right: 28),
        child: Row(
          children: [
            if (onMenu != null) ...[
              IconButton(tooltip: tr.menu, onPressed: onMenu, icon: const Icon(Icons.menu)),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${tr.administration}  /  $title',
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headlineSmall?.copyWith(fontSize: 24),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: tr.notifications,
              onPressed: () => showNotificationsPanel(context),
              icon: Badge(
                isLabelVisible: unread > 0,
                backgroundColor: AppColors.terracotta,
                label: Text(unread > 99 ? '99+' : '$unread'),
                child: const Icon(Icons.notifications_outlined),
              ),
            ),
            const SizedBox(width: 16),
            Tooltip(
              message: auth.session?.fullName ?? '',
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.terracottaSoft,
                foregroundColor: AppColors.terracotta,
                child: Text(
                  auth.session?.firstName.characters.first.toUpperCase() ?? '?',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            if (showName) ...[
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(auth.session?.fullName ?? '', style: theme.textTheme.labelLarge),
                  Text(
                    tr.roleAdministrator,
                    style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

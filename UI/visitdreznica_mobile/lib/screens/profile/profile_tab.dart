import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Odjava'),
        content: const Text('Da li se želite odjaviti?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Odustani')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Odjavi se')),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<AuthProvider>().logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AuthProvider>().session;
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Center(
          child: CircleAvatar(
            radius: 40,
            child: Text(session?.firstName.characters.first.toUpperCase() ?? '?', style: theme.textTheme.headlineMedium),
          ),
        ),
        const SizedBox(height: 12),
        Text(session?.fullName ?? '', textAlign: TextAlign.center, style: theme.textTheme.titleLarge),
        Text('@${session?.username ?? ''}', textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 24),
        const Card(
          child: ListTile(
            leading: Icon(Icons.edit_outlined),
            title: Text('Uredi profil'),
            subtitle: Text('Uskoro'),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.logout, color: theme.colorScheme.error),
            title: Text('Odjava', style: TextStyle(color: theme.colorScheme.error)),
            onTap: () => _logout(context),
          ),
        ),
      ],
    );
  }
}
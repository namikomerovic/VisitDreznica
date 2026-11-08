import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import 'change_password_screen.dart';
import 'edit_profile_screen.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late final ProfileService _service;

  AppUser? _profile;
  String? _error;
  int _imageVersion = 0;
  bool _imageBusy = false;

  @override
  void initState() {
    super.initState();
    _service = ProfileService(context.read<ApiClient>());
    _load();
  }

  Future<void> _load() async {
    try {
      final profile = await _service.get();
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _error = null;
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  void _showMessage(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  Future<void> _edit(AppUser profile) async {
    final auth = context.read<AuthProvider>();
    final updated = await Navigator.of(context).push<AppUser>(
      MaterialPageRoute(builder: (_) => EditProfileScreen(profile: profile)),
    );

    if (updated == null || !mounted) return;
    setState(() => _profile = updated);
    auth.updateFullName(updated.fullName);
    _showMessage('Profil je sačuvan.');
  }

  Future<void> _changePassword() async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
    );

    if (changed == true && mounted) _showMessage('Lozinka je promijenjena.');
  }

  Future<void> _photoOptions(AppUser profile) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Odaberi iz galerije'),
              onTap: () => Navigator.pop(context, 'pick'),
            ),
            if (profile.hasImage)
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: const Text('Ukloni sliku'),
                onTap: () => Navigator.pop(context, 'remove'),
              ),
          ],
        ),
      ),
    );

    if (action == 'pick') await _pickPhoto();
    if (action == 'remove') await _removePhoto();
  }

  Future<void> _pickPhoto() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (picked == null || !mounted) return;
    setState(() => _imageBusy = true);

    try {
      final bytes = await picked.readAsBytes();
      final isPng = picked.name.toLowerCase().endsWith('.png');

      await _service.setImage(
        bytes,
        fileName: picked.name,
        contentType: isPng ? 'image/png' : 'image/jpeg',
      );

      _imageVersion++;
      await _load();
    } on ApiException catch (e) {
      if (mounted) _showMessage(e.message);
    } finally {
      if (mounted) setState(() => _imageBusy = false);
    }
  }

  Future<void> _removePhoto() async {
    setState(() => _imageBusy = true);

    try {
      await _service.deleteImage();
      _imageVersion++;
      await _load();
    } on ApiException catch (e) {
      if (mounted) _showMessage(e.message);
    } finally {
      if (mounted) setState(() => _imageBusy = false);
    }
  }

  Future<void> _logout() async {
    final auth = context.read<AuthProvider>();
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

    if (confirmed == true) await auth.logout();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final session = context.watch<AuthProvider>().session;
    final profile = _profile;
    final fullName = profile?.fullName ?? session?.fullName ?? '';
    final initial = fullName.isEmpty
        ? '?'
        : fullName.characters.first.toUpperCase();

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: GestureDetector(
              onTap: profile == null || _imageBusy
                  ? null
                  : () => _photoOptions(profile),
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 48,
                    child: _imageBusy
                        ? const CircularProgressIndicator()
                        : profile != null && profile.hasImage
                        ? ClipOval(
                            child: AuthImage(
                              url: _service.imageUrl(version: _imageVersion),
                              width: 96,
                              height: 96,
                            ),
                          )
                        : Text(initial, style: theme.textTheme.headlineMedium),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: theme.colorScheme.primary,
                      child: Icon(
                        Icons.photo_camera_outlined,
                        size: 18,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            fullName,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge,
          ),
          Text(
            '@${profile?.username ?? session?.username ?? ''}',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          if (_error != null && profile == null)
            Center(
              child: TextButton(
                onPressed: _load,
                child: Text('$_error Pokušaj ponovo.'),
              ),
            ),
          if (profile != null)
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: Text(profile.email),
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone_outlined),
                    title: Text(profile.phoneNumber ?? 'Telefon nije unesen'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.location_city_outlined),
                    title: Text(profile.cityName),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: const Text('Uredi profil'),
                  trailing: const Icon(Icons.chevron_right),
                  enabled: profile != null,
                  onTap: profile == null ? null : () => _edit(profile),
                ),
                ListTile(
                  leading: const Icon(Icons.password_outlined),
                  title: const Text('Promijeni lozinku'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _changePassword,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Izgled', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 12),
                  const SizedBox(
                    width: double.infinity,
                    child: ThemeModeSelector(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: Icon(Icons.logout, color: theme.colorScheme.error),
              title: Text(
                'Odjava',
                style: TextStyle(color: theme.colorScheme.error),
              ),
              onTap: _logout,
            ),
          ),
        ],
      ),
    );
  }
}

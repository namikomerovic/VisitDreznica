import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../widgets/paged_table.dart';
import 'user_form_screen.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final _tableKey = GlobalKey<PagedTableState<AppUser>>();
  final _textController = TextEditingController();
  late final UserService _service;
  late final Future<List<LookupItem>> _roles;

  Timer? _debounce;
  int? _roleId;
  bool? _isActive;
  int _queryVersion = 0;

  @override
  void initState() {
    super.initState();
    final api = context.read<ApiClient>();
    _service = UserService(api);
    _roles = LookupService(api, 'Roles').getAll();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _textController.dispose();
    super.dispose();
  }

  void _filtersChanged() => setState(() => _queryVersion++);

  Future<void> _openForm({int? id}) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => UserFormScreen(userId: id)),
    );

    if (changed == true) _tableKey.currentState?.reload();
  }

  static String _roleLabel(String role) => switch (role) {
        AppRoles.admin => 'Administrator',
        AppRoles.guest => 'Gost',
        _ => role,
      };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _textController,
                      onChanged: (_) {
                        _debounce?.cancel();
                        _debounce = Timer(const Duration(milliseconds: 400), _filtersChanged);
                      },
                      decoration: const InputDecoration(
                        isDense: true,
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Ime, korisničko ime ili e-mail',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 190,
                    child: FutureBuilder<List<LookupItem>>(
                      future: _roles,
                      builder: (context, snapshot) => DropdownButtonFormField<int?>(
                        initialValue: _roleId,
                        decoration: const InputDecoration(labelText: 'Uloga', isDense: true, border: OutlineInputBorder()),
                        items: [
                          const DropdownMenuItem(value: null, child: Text('Sve uloge')),
                          for (final role in snapshot.data ?? const <LookupItem>[])
                            DropdownMenuItem(value: role.id, child: Text(_roleLabel(role.name))),
                        ],
                        onChanged: (value) {
                          _roleId = value;
                          _filtersChanged();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 170,
                    child: DropdownButtonFormField<bool?>(
                      initialValue: _isActive,
                      decoration: const InputDecoration(labelText: 'Status', isDense: true, border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: null, child: Text('Svi')),
                        DropdownMenuItem(value: true, child: Text('Aktivni')),
                        DropdownMenuItem(value: false, child: Text('Neaktivni')),
                      ],
                      onChanged: (value) {
                        _isActive = value;
                        _filtersChanged();
                      },
                    ),
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: () => _openForm(),
                    icon: const Icon(Icons.person_add_alt),
                    label: const Text('Dodaj korisnika'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: PagedTable<AppUser>(
                key: _tableKey,
                query: _queryVersion,
                load: (page, pageSize) => _service.getPage(
                  UserSearch(text: _textController.text, roleId: _roleId, isActive: _isActive),
                  page: page,
                  pageSize: pageSize,
                ),
                onRowTap: (user) => _openForm(id: user.id),
                emptyText: 'Nema korisnika za prikaz.',
                columns: [
                  PagedColumn(
                    header: '',
                    flex: 1,
                    cell: (user) => CircleAvatar(
                      radius: 18,
                      child: user.hasImage
                          ? ClipOval(child: AuthImage(url: _service.imageUrl(user.id), width: 36, height: 36))
                          : Text(user.firstName.characters.first.toUpperCase()),
                    ),
                  ),
                  PagedColumn(header: 'Ime i prezime', flex: 3, cell: (user) => Text(user.fullName)),
                  PagedColumn(header: 'Korisničko ime', flex: 3, cell: (user) => Text(user.username)),
                  PagedColumn(
                    header: 'E-mail',
                    flex: 4,
                    cell: (user) => Text(user.email, overflow: TextOverflow.ellipsis),
                  ),
                  PagedColumn(header: 'Grad', flex: 2, cell: (user) => Text(user.cityName)),
                  PagedColumn(
                    header: 'Uloge',
                    flex: 2,
                    cell: (user) => Text(user.roles.map(_roleLabel).join(', ')),
                  ),
                  PagedColumn(
                    header: 'Status',
                    flex: 2,
                    alignEnd: true,
                    cell: (user) => Text(
                      user.isActive ? 'Aktivan' : 'Neaktivan',
                      style: TextStyle(color: user.isActive ? const Color(0xFF16A34A) : scheme.outline),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
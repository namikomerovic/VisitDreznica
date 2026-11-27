import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../widgets/adaptive_row.dart';
import '../../widgets/dialogs.dart';
import '../../widgets/error_view.dart';

class UserFormScreen extends StatefulWidget {
  const UserFormScreen({super.key, this.userId});

  final int? userId;

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _passwordConfirmation = TextEditingController();

  late final UserService _service;
  late final ApiClient _api;

  AppUser? _user;
  int? _cityId;
  bool _isActive = true;
  final Set<int> _roleIds = {};
  List<City> _cities = [];
  List<LookupItem> _roles = [];

  bool _loading = true;
  bool _saving = false;
  bool _changed = false;
  bool _obscure = true;
  String? _loadError;
  Map<String, String> _serverErrors = {};

  bool get _isEdit => _user != null;
  bool get _isSelf =>
      _user != null &&
      _user!.id == context.read<AuthProvider>().session?.userId;

  @override
  void initState() {
    super.initState();
    _api = context.read<ApiClient>();
    _service = UserService(_api);
    _load();
  }

  @override
  void dispose() {
    for (final controller in [
      _firstName,
      _lastName,
      _username,
      _email,
      _phone,
      _password,
      _passwordConfirmation,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });

    try {
      final cities = await CityService(_api).getAll();
      final roles = await LookupService(_api, 'Roles').getAll();
      final user = widget.userId == null
          ? null
          : await _service.getById(widget.userId!);

      if (!mounted) return;

      setState(() {
        _cities = CityService.sortHomeFirst(cities);
        _roles = roles;

        if (user != null) {
          _fill(user);
        } else {
          final guest = roles
              .where((x) => x.name == AppRoles.guest)
              .firstOrNull;
          if (guest != null) _roleIds.add(guest.id);
        }
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _loadError = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _fill(AppUser user) {
    _user = user;
    _firstName.text = user.firstName;
    _lastName.text = user.lastName;
    _username.text = user.username;
    _email.text = user.email;
    _phone.text = user.phoneNumber ?? '';
    _cityId = user.cityId;
    _isActive = user.isActive;
    _roleIds
      ..clear()
      ..addAll(
        _roles
            .where((role) => user.roles.contains(role.name))
            .map((role) => role.id),
      );
    _password.clear();
    _passwordConfirmation.clear();
  }

  Future<void> _save() async {
    setState(() => _serverErrors = {});

    if (!_formKey.currentState!.validate()) return;

    if (_roleIds.isEmpty) {
      showMessage(context, tr.selectAtLeastOneRole, isError: true);
      return;
    }

    final password = _password.text.isEmpty ? null : _password.text;
    final request = UserUpsertRequest(
      firstName: _firstName.text.trim(),
      lastName: _lastName.text.trim(),
      email: _email.text.trim(),
      username: _username.text.trim(),
      phoneNumber: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
      cityId: _cityId!,
      roleIds: _roleIds.toList(),
      isActive: _isActive,
      password: password,
    );

    setState(() => _saving = true);

    try {
      final wasNew = !_isEdit;
      final saved = wasNew
          ? await _service.insert(request)
          : await _service.update(_user!.id, request);

      if (!mounted) return;

      setState(() {
        _changed = true;
        _fill(saved);
      });

      final sessionNote = !wasNew && (!saved.isActive || password != null)
          ? ' ${tr.userLoggedOutEverywhere}'
          : '';
      showMessage(
        context,
        wasNew ? tr.userAdded : '${tr.changesSaved}$sessionNote',
      );
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;

      if (e.fieldErrors.isNotEmpty) {
        setState(() => _serverErrors = normalizeServerErrors(e.fieldErrors));
      } else {
        showMessage(context, e.message, isError: true);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    final confirmed = await showConfirmDialog(
      context,
      title: tr.deletingUser,
      message: tr.deleteUserQuestion(_user!.fullName),
      confirmLabel: tr.delete,
      destructive: true,
    );

    if (!confirmed) return;

    try {
      await _service.delete(_user!.id);
      if (mounted) Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (mounted) showMessage(context, e.message, isError: true);
    }
  }

  String? _serverError(String field) => _serverErrors[field.toLowerCase()];

  static String _roleLabel(String role) => switch (role) {
    AppRoles.admin => tr.roleAdministrator,
    AppRoles.guest => tr.roleGuest,
    _ => role,
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: tr.back,
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, _changed),
        ),
        title: Text(_user?.fullName ?? tr.newUser),
        actions: [
          if (_isEdit && !_isSelf)
            TextButton.icon(
              onPressed: _saving ? null : _delete,
              icon: Icon(Icons.delete_outline, color: scheme.error),
              label: Text(tr.delete, style: TextStyle(color: scheme.error)),
            ),
          const SizedBox(width: 16),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_loadError != null) return ErrorView(message: _loadError!, onRetry: _load);

    final theme = Theme.of(context);
    final user = _user;

    Widget field(
      TextEditingController controller,
      String label,
      String serverField, {
      String? Function(String?)? validator,
      int? maxLength,
      String? hint,
    }) => TextFormField(
      controller: controller,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        errorText: _serverError(serverField),
      ),
      validator: validator,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr.personalData,
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        AdaptiveRow(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: field(
                                _firstName,
                                tr.firstNameRequiredShort,
                                'firstName',
                                maxLength: 50,
                                validator: (v) => validateLength(
                                  v,
                                  1,
                                  50,
                                  tr.enterFirstName,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: field(
                                _lastName,
                                tr.lastNameRequiredShort,
                                'lastName',
                                maxLength: 50,
                                validator: (v) => validateLength(
                                  v,
                                  1,
                                  50,
                                  tr.enterLastName,
                                ),
                              ),
                            ),
                          ],
                        ),
                        AdaptiveRow(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: field(
                                _email,
                                tr.emailRequiredLabel,
                                'email',
                                validator: validateEmail,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: field(
                                _phone,
                                tr.phone,
                                'phoneNumber',
                                hint: tr.phoneExample,
                                validator: validateOptionalPhone,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<int>(
                          initialValue: _cityId,
                          decoration: InputDecoration(
                            labelText: tr.cityRequiredLabel,
                            border: const OutlineInputBorder(),
                            errorText: _serverError('cityId'),
                          ),
                          items: [
                            for (final city in _cities)
                              DropdownMenuItem(
                                value: city.id,
                                child: Text(
                                  '${city.name} (${city.countryName})',
                                ),
                              ),
                          ],
                          onChanged: (value) => setState(() => _cityId = value),
                          validator: (value) =>
                              value == null ? tr.selectCity : null,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tr.access, style: theme.textTheme.titleMedium),
                        const SizedBox(height: 16),
                        field(
                          _username,
                          tr.usernameRequiredLabel,
                          'username',
                          validator: validateUsername,
                        ),
                        const SizedBox(height: 16),
                        AdaptiveRow(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _password,
                                obscureText: _obscure,
                                decoration: InputDecoration(
                                  labelText: _isEdit
                                      ? tr.newPassword
                                      : tr.passwordRequiredLabel,
                                  helperText: _isEdit
                                      ? tr.leaveEmptyPassword
                                      : null,
                                  border: const OutlineInputBorder(),
                                  errorText: _serverError(
                                    _isEdit ? 'newPassword' : 'password',
                                  ),
                                  suffixIcon: IconButton(
                                    tooltip: _obscure
                                        ? tr.showPassword
                                        : tr.hidePassword,
                                    icon: Icon(
                                      _obscure
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                    ),
                                    onPressed: () =>
                                        setState(() => _obscure = !_obscure),
                                  ),
                                ),
                                validator: (value) =>
                                    validatePassword(value, required: !_isEdit),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _passwordConfirmation,
                                obscureText: _obscure,
                                decoration: InputDecoration(
                                  labelText: _isEdit
                                      ? tr.confirmNewPasswordOptional
                                      : tr.confirmPassword,
                                  border: const OutlineInputBorder(),
                                ),
                                validator: (value) => value == _password.text
                                    ? null
                                    : tr.passwordsDoNotMatch,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(tr.rolesRequired, style: theme.textTheme.titleSmall),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            for (final role in _roles)
                              FilterChip(
                                label: Text(_roleLabel(role.name)),
                                selected: _roleIds.contains(role.id),
                                onSelected:
                                    _isSelf && role.name == AppRoles.admin
                                    ? null
                                    : (selected) => setState(
                                        () => selected
                                            ? _roleIds.add(role.id)
                                            : _roleIds.remove(role.id),
                                      ),
                              ),
                          ],
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(tr.activeMasculine),
                          subtitle: Text(
                            _isSelf ? tr.cannotDeactivateSelf : tr.inactiveUserHint,
                          ),
                          value: _isActive,
                          onChanged: _isSelf
                              ? null
                              : (value) => setState(() => _isActive = value),
                        ),
                        if (user != null)
                          Text(
                            tr.registeredAt(Formatters.dateTime(user.createdAt)),
                            style: theme.textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    onPressed: _saving ? null : _save,
                    icon: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(
                      _isEdit ? tr.saveChanges : tr.addUser,
                    ),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(180, 48),
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../widgets/message_box.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.profile});

  final AppUser profile;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final ProfileService _service;
  late final Future<List<City>> _cities;

  late int _cityId;
  bool _saving = false;
  String? _error;
  Map<String, String> _serverErrors = {};

  @override
  void initState() {
    super.initState();
    final profile = widget.profile;
    _firstName = TextEditingController(text: profile.firstName);
    _lastName = TextEditingController(text: profile.lastName);
    _email = TextEditingController(text: profile.email);
    _phone = TextEditingController(text: profile.phoneNumber ?? '');
    _cityId = profile.cityId;

    final api = context.read<ApiClient>();
    _service = ProfileService(api);
    _cities = CityService(api).getForRegistration();
  }

  @override
  void dispose() {
    for (final controller in [_firstName, _lastName, _email, _phone]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _error = null;
      _serverErrors = {};
    });

    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _saving = true);

    try {
      final phone = _phone.text.trim();
      final updated = await _service.update(
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        email: _email.text.trim(),
        phoneNumber: phone.isEmpty ? null : phone,
        cityId: _cityId,
      );

      if (mounted) Navigator.of(context).pop(updated);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        if (e.fieldErrors.isNotEmpty) {
          _serverErrors = normalizeServerErrors(e.fieldErrors);
        } else {
          _error = e.message;
        }
      });
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  InputDecoration _decoration(String label, String field, {IconData? icon, String? hint}) => InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon == null ? null : Icon(icon),
        border: const OutlineInputBorder(),
        errorText: _serverErrors[field.toLowerCase()],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Uredi profil')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_error != null) MessageBox(text: _error!, isError: true),
                TextFormField(
                  controller: _firstName,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: _decoration('Ime *', 'firstName', icon: Icons.badge_outlined),
                  validator: (v) => validateLength(v, 1, 50, 'Unesite ime (najviše 50 znakova).'),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _lastName,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: _decoration('Prezime *', 'lastName', icon: Icons.badge_outlined),
                  validator: (v) => validateLength(v, 1, 50, 'Unesite prezime (najviše 50 znakova).'),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  decoration: _decoration('E-mail *', 'email', icon: Icons.email_outlined),
                  validator: validateEmail,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  decoration: _decoration('Telefon', 'phoneNumber', icon: Icons.phone_outlined, hint: '061 234 567'),
                  validator: validateOptionalPhone,
                ),
                const SizedBox(height: 14),
                FutureBuilder<List<City>>(
                  future: _cities,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const MessageBox(text: 'Gradove nije moguće učitati. Provjerite vezu.', isError: true);
                    }

                    final cities = snapshot.data;
                    if (cities == null) {
                      return const Padding(
                        padding: EdgeInsets.all(12),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    return DropdownButtonFormField<int>(
                      initialValue: cities.any((x) => x.id == _cityId) ? _cityId : null,
                      isExpanded: true,
                      decoration: _decoration('Grad *', 'cityId', icon: Icons.location_city_outlined),
                      items: [
                        for (final city in cities)
                          DropdownMenuItem(value: city.id, child: Text('${city.name}, ${city.countryName}')),
                      ],
                      onChanged: _saving ? null : (value) => setState(() => _cityId = value!),
                      validator: (value) => value == null ? 'Odaberite grad.' : null,
                    );
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  'Korisničko ime (@${widget.profile.username}) se ne može mijenjati.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _saving ? null : _save,
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                  child: _saving
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
                      : const Text('Sačuvaj'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
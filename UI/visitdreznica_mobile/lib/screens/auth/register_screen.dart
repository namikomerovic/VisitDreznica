import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../widgets/message_box.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _passwordConfirmation = TextEditingController();

  late final Future<List<City>> _cities;
  int? _cityId;
  bool _loading = false;
  bool _obscure = true;
  String? _error;
  Map<String, String> _serverErrors = {};

  @override
  void initState() {
    super.initState();
    _cities = CityService(context.read<ApiClient>()).getForRegistration();
  }

  @override
  void dispose() {
    for (final controller in [_firstName, _lastName, _username, _email, _phone, _password, _passwordConfirmation]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _error = null;
      _serverErrors = {};
    });

    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _loading = true);

    try {
      await context.read<AuthProvider>().register(RegisterRequest(
            firstName: _firstName.text.trim(),
            lastName: _lastName.text.trim(),
            email: _email.text.trim(),
            username: _username.text.trim(),
            phoneNumber: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
            cityId: _cityId!,
            password: _password.text,
          ));
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
      if (mounted) setState(() => _loading = false);
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
      appBar: AppBar(title: const Text('Registracija')),
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
                  textInputAction: TextInputAction.next,
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

                    return DropdownButtonFormField<int>(
                      initialValue: _cityId,
                      isExpanded: true,
                      decoration: _decoration('Grad *', 'cityId', icon: Icons.location_city_outlined),
                      items: [
                        for (final city in snapshot.data ?? const <City>[])
                          DropdownMenuItem(value: city.id, child: Text('${city.name}, ${city.countryName}')),
                      ],
                      onChanged: (value) => setState(() => _cityId = value),
                      validator: (value) => value == null ? 'Odaberite grad.' : null,
                    );
                  },
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _username,
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  decoration: _decoration('Korisničko ime *', 'username', icon: Icons.person_outline),
                  validator: validateUsername,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _password,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.next,
                  decoration: _decoration('Lozinka *', 'password', icon: Icons.lock_outline).copyWith(
                    helperText: 'Najmanje 8 znakova, slovo i broj.',
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (v) => validatePassword(v, required: true),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _passwordConfirmation,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  decoration: _decoration('Potvrda lozinke *', 'passwordConfirmation', icon: Icons.lock_outline),
                  validator: (v) => v == _password.text ? null : 'Lozinke se ne podudaraju.',
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _loading ? null : _submit,
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                  child: _loading
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
                      : const Text('Kreiraj račun'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
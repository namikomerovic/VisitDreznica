import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../widgets/message_box.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _new = TextEditingController();
  final _confirmation = TextEditingController();

  bool _obscure = true;
  bool _saving = false;
  String? _error;
  Map<String, String> _serverErrors = {};

  @override
  void dispose() {
    _current.dispose();
    _new.dispose();
    _confirmation.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _error = null;
      _serverErrors = {};
    });

    if (!_formKey.currentState!.validate()) return;

    final service = ProfileService(context.read<ApiClient>());
    FocusScope.of(context).unfocus();
    setState(() => _saving = true);

    try {
      await service.changePassword(currentPassword: _current.text, newPassword: _new.text);
      if (mounted) Navigator.of(context).pop(true);
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

  InputDecoration _decoration(String label, String field, {String? helper}) => InputDecoration(
        labelText: label,
        helperText: helper,
        prefixIcon: const Icon(Icons.lock_outline),
        border: const OutlineInputBorder(),
        errorText: _serverErrors[field.toLowerCase()],
        suffixIcon: IconButton(
          icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Promijeni lozinku')),
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
                  controller: _current,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.next,
                  decoration: _decoration('Trenutna lozinka *', 'currentPassword'),
                  validator: (v) => (v == null || v.isEmpty) ? 'Unesite trenutnu lozinku.' : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _new,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.next,
                  decoration: _decoration('Nova lozinka *', 'newPassword', helper: 'Najmanje 8 znakova, slovo i broj.'),
                  validator: (v) {
                    final basic = validatePassword(v, required: true);
                    if (basic != null) return basic;
                    return v == _current.text ? 'Nova lozinka mora biti različita od trenutne.' : null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _confirmation,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _save(),
                  decoration: _decoration('Potvrda nove lozinke *', 'newPasswordConfirmation'),
                  validator: (v) => v == _new.text ? null : 'Lozinke se ne podudaraju.',
                ),
                const SizedBox(height: 12),
                Text(
                  'Nakon promjene bićete odjavljeni sa svih drugih uređaja.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _saving ? null : _save,
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                  child: _saving
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
                      : const Text('Promijeni lozinku'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;
  bool _obscurePassword = true;
  String? _error;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await context.read<AuthProvider>().login(_usernameController.text, _passwordController.text);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sessionMessage = context.watch<AuthProvider>().sessionMessage;

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(child: AppLogo(size: 140)),
                      const SizedBox(height: 12),
                      Text('Visit Drežnica', textAlign: TextAlign.center, style: theme.textTheme.headlineSmall),
                      Text('Administracija', textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
                      const SizedBox(height: 28),
                      if (sessionMessage != null && _error == null) ...[
                        _MessageBox(text: sessionMessage, isError: false),
                        const SizedBox(height: 16),
                      ],
                      if (_error != null) ...[
                        _MessageBox(text: _error!, isError: true),
                        const SizedBox(height: 16),
                      ],
                      TextFormField(
                        controller: _usernameController,
                        enabled: !_loading,
                        autofocus: true,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Korisničko ime',
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            (value == null || value.trim().isEmpty) ? 'Unesite korisničko ime.' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        enabled: !_loading,
                        obscureText: _obscurePassword,
                        onFieldSubmitted: (_) => _submit(),
                        decoration: InputDecoration(
                          labelText: 'Lozinka',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            tooltip: _obscurePassword ? 'Prikaži lozinku' : 'Sakrij lozinku',
                            icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: (value) => (value == null || value.isEmpty) ? 'Unesite lozinku.' : null,
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: _loading ? null : _submit,
                        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                        child: _loading
                            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
                            : const Text('Prijava'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageBox extends StatelessWidget {
  const _MessageBox({required this.text, required this.isError});

  final String text;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isError ? scheme.errorContainer : scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(isError ? Icons.error_outline : Icons.info_outline,
              color: isError ? scheme.onErrorContainer : scheme.onSecondaryContainer),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: TextStyle(color: isError ? scheme.onErrorContainer : scheme.onSecondaryContainer)),
          ),
        ],
      ),
    );
  }
}
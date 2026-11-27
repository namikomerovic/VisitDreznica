import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import '../../widgets/email_field.dart';
import '../../widgets/message_box.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailFormKey = GlobalKey<FormState>();
  final _resetFormKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _code = TextEditingController();
  final _password = TextEditingController();
  final _confirmation = TextEditingController();
  late final PasswordResetService _service;

  bool _codeSent = false;
  bool _busy = false;
  bool _obscure = true;
  String? _error;
  String? _info;
  Map<String, String> _serverErrors = {};

  @override
  void initState() {
    super.initState();
    _service = PasswordResetService(context.read<ApiClient>());
  }

  @override
  void dispose() {
    for (final controller in [_email, _code, _password, _confirmation]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
      _serverErrors = {};
    });

    try {
      await action();
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
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _sendCode() async {
    if (!_emailFormKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    await _run(() async {
      await _service.requestCode(_email.text);
      if (!mounted) return;
      setState(() {
        _codeSent = true;
        _info = tr.resetCodeSent(_email.text.trim());
      });
    });
  }

  Future<void> _resetPassword() async {
    if (!_resetFormKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    await _run(() async {
      await _service.confirm(email: _email.text, code: _code.text, newPassword: _password.text);
      if (mounted) Navigator.of(context).pop(true);
    });
  }

  InputDecoration _decoration(String label, String field, IconData icon, {String? helper, Widget? suffix}) =>
      InputDecoration(
        labelText: label,
        helperText: helper,
        prefixIcon: Icon(icon),
        suffixIcon: suffix,
        border: const OutlineInputBorder(),
        errorText: _serverErrors[field.toLowerCase()],
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(tr.forgottenPassword)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ContentWidth(child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _codeSent
                    ? tr.enterCodeAndNewPassword
                    : tr.enterAccountEmail,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              if (_error != null) MessageBox(text: _error!, isError: true),
              if (_info != null && _error == null) MessageBox(text: _info!),
              Form(
                key: _emailFormKey,
                child: EmailField(
                  controller: _email,
                  enabled: !_busy && !_codeSent,
                  decoration: _decoration(tr.email, 'email', Icons.email_outlined),
                  validator: validateEmail,
                ),
              ),
              const SizedBox(height: 16),
              if (!_codeSent)
                FilledButton(
                  onPressed: _busy ? null : _sendCode,
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                  child: _busy
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
                      : Text(tr.sendCode),
                )
              else
                Form(
                  key: _resetFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _code,
                        enabled: !_busy,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        textInputAction: TextInputAction.next,
                        decoration: _decoration(tr.codeFromEmail, 'code', Icons.pin_outlined),
                        validator: (value) => RegExp(r'^\d{6}$').hasMatch(value?.trim() ?? '')
                            ? null
                            : tr.codeSixDigits,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _password,
                        enabled: !_busy,
                        obscureText: _obscure,
                        textInputAction: TextInputAction.next,
                        decoration: _decoration(
                          tr.newPassword,
                          'newPassword',
                          Icons.lock_outline,
                          helper: tr.passwordHint,
                          suffix: IconButton(
                            icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          ),
                        ),
                        validator: (value) => validatePassword(value, required: true),
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _confirmation,
                        enabled: !_busy,
                        obscureText: _obscure,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _resetPassword(),
                        decoration: _decoration(tr.confirmNewPassword, 'newPasswordConfirmation', Icons.lock_outline),
                        validator: (value) => value == _password.text ? null : tr.passwordsDoNotMatch,
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: _busy ? null : _resetPassword,
                        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                        child: _busy
                            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
                            : Text(tr.setNewPassword),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _busy ? null : _sendCode,
                        child: Text(tr.resendCode),
                      ),
                    ],
                  ),
                ),
            ],
          )),
        ),
      ),
    );
  }
}

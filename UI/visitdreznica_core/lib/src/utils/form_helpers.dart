import 'package:flutter/services.dart';

import '../l10n/locale_controller.dart';

final decimalInputFormatter = FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'));

double? parseDecimal(String? value) =>
    value == null ? null : double.tryParse(value.trim().replaceAll(',', '.'));

String formatDecimal(double value) {
  final text = value.toStringAsFixed(2);
  return LocaleController.languageCode == 'en' ? text : text.replaceAll('.', ',');
}

String? validateIntRange(String? value, int min, int max, String message) {
  final number = int.tryParse(value?.trim() ?? '');
  return number == null || number < min || number > max ? message : null;
}

String? validateDecimalRange(String? value, double min, double max, String message) {
  final number = parseDecimal(value);
  return number == null || number < min || number > max ? message : null;
}

String? validateLength(String? value, int min, int max, String message) {
  final length = value?.trim().length ?? 0;
  return length < min || length > max ? message : null;
}

Map<String, String> normalizeServerErrors(Map<String, List<String>> errors) => {
      for (final entry in errors.entries) entry.key.replaceFirst(r'$.', '').toLowerCase(): entry.value.first,
    };

final _usernamePattern = RegExp(r'^[a-zA-Z0-9._]{3,50}$');
final _passwordPattern = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{8,}$');
final _phonePattern = RegExp(r'^\+?[0-9 ]{6,20}$');
final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

String? validateUsername(String? value) => _usernamePattern.hasMatch(value?.trim() ?? '')
    ? null
    : tr.validationUsername;

String? validatePassword(String? value, {required bool required}) {
  if ((value == null || value.isEmpty) && !required) return null;
  return _passwordPattern.hasMatch(value ?? '')
      ? null
      : tr.validationPassword;
}

String? validateEmail(String? value) {
  final trimmed = value?.trim() ?? '';
  if (trimmed.isEmpty) return tr.validationEmailRequired;
  if (trimmed.length > 100) return tr.validationEmailLength;
  return _emailPattern.hasMatch(trimmed) ? null : tr.validationEmail;
}

String? validateOptionalPhone(String? value) {
  final trimmed = value?.trim() ?? '';
  return trimmed.isEmpty || _phonePattern.hasMatch(trimmed)
      ? null
      : tr.validationPhone;
}
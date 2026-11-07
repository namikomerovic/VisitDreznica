import 'package:flutter/services.dart';

final decimalInputFormatter = FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'));

double? parseDecimal(String? value) =>
    value == null ? null : double.tryParse(value.trim().replaceAll(',', '.'));

String formatDecimal(double value) => value.toStringAsFixed(2).replaceAll('.', ',');

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
    : 'Korisničko ime mora imati 3–50 znakova: slova, brojevi, tačka ili donja crta.';

String? validatePassword(String? value, {required bool required}) {
  if ((value == null || value.isEmpty) && !required) return null;
  return _passwordPattern.hasMatch(value ?? '')
      ? null
      : 'Najmanje 8 znakova, uključujući barem jedno slovo i jedan broj.';
}

String? validateEmail(String? value) {
  final trimmed = value?.trim() ?? '';
  if (trimmed.isEmpty) return 'E-mail je obavezan.';
  if (trimmed.length > 100) return 'E-mail može imati najviše 100 znakova.';
  return _emailPattern.hasMatch(trimmed) ? null : 'Unesite ispravnu e-mail adresu, npr. ime@domena.ba.';
}

String? validateOptionalPhone(String? value) {
  final trimmed = value?.trim() ?? '';
  return trimmed.isEmpty || _phonePattern.hasMatch(trimmed)
      ? null
      : 'Unesite ispravan broj, npr. 061 234 567 ili +387 61 234 567.';
}
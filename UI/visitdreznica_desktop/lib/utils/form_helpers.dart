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
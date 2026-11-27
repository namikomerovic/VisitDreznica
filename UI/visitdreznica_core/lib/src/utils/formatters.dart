import 'package:intl/intl.dart';

import '../l10n/locale_controller.dart';

abstract final class Formatters {
  static bool get _en => LocaleController.languageCode == 'en';

  static String get _locale => LocaleController.languageCode;

  static const _monthsBs = ['Jan', 'Feb', 'Mar', 'Apr', 'Maj', 'Jun', 'Jul', 'Aug', 'Sep', 'Okt', 'Nov', 'Dec'];

  static const _monthsLongBs = [
    'januar', 'februar', 'mart', 'april', 'maj', 'juni',
    'juli', 'august', 'septembar', 'oktobar', 'novembar', 'decembar',
  ];

  static String money(num value) => '${NumberFormat('#,##0.00', _locale).format(value)} KM';

  static String decimal(num value) => NumberFormat('#,##0.0', _locale).format(value);

  static String date(DateTime value) =>
      DateFormat(_en ? 'dd/MM/yyyy' : 'dd.MM.yyyy.', _locale).format(value.toLocal());

  static String dateTime(DateTime value) =>
      DateFormat(_en ? 'dd/MM/yyyy HH:mm' : 'dd.MM.yyyy. HH:mm', _locale).format(value.toLocal());

  static String time(DateTime value) => DateFormat('HH:mm', _locale).format(value.toLocal());

  static String relative(DateTime value) {
    final difference = DateTime.now().difference(value.toLocal());

    if (difference.inMinutes < 1) return tr.justNow;
    if (difference.inMinutes < 60) return tr.minutesAgo(difference.inMinutes);
    if (difference.inHours < 24) return tr.hoursAgo(difference.inHours);
    if (difference.inDays < 7) return tr.daysAgo(difference.inDays);

    return date(value);
  }

  static String duration(int minutes) {
    final hours = minutes ~/ 60;
    final rest = minutes % 60;

    if (hours == 0) return '$rest min';
    if (rest == 0) return '$hours h';
    return '$hours h $rest min';
  }

  static String monthShort(int month) =>
      _en ? DateFormat('MMM', 'en').format(DateTime(2000, month)) : _monthsBs[month - 1];

  /// Naziv mjeseca s godinom, npr. "novembar 2026" / "November 2026".
  static String monthYear(DateTime value) =>
      _en ? DateFormat('MMMM yyyy', 'en').format(value) : '${_monthsLongBs[value.month - 1]} ${value.year}';
}

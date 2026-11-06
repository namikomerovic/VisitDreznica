import 'package:intl/intl.dart';

abstract final class Formatters {
  static final NumberFormat _money = NumberFormat('#,##0.00', 'bs');
  static final NumberFormat _decimal = NumberFormat('#,##0.0', 'bs');

  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'Maj', 'Jun', 'Jul', 'Aug', 'Sep', 'Okt', 'Nov', 'Dec'];

  static String money(num value) => '${_money.format(value)} KM';

  static String decimal(num value) => _decimal.format(value);

  static String date(DateTime value) => DateFormat('dd.MM.yyyy.', 'bs').format(value.toLocal());

  static String dateTime(DateTime value) => DateFormat('dd.MM.yyyy. HH:mm', 'bs').format(value.toLocal());

  static String time(DateTime value) => DateFormat('HH:mm', 'bs').format(value.toLocal());

    static String relative(DateTime value) {
    final difference = DateTime.now().difference(value.toLocal());

    if (difference.inMinutes < 1) return 'upravo';
    if (difference.inMinutes < 60) return 'prije ${difference.inMinutes} min';
    if (difference.inHours < 24) return 'prije ${difference.inHours} h';
    if (difference.inDays < 7) return 'prije ${difference.inDays} d';

    return date(value);
  }

  static String monthShort(int month) => _months[month - 1];
}
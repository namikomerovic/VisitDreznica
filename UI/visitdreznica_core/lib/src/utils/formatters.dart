import 'package:intl/intl.dart';

abstract final class Formatters {
  static final NumberFormat _money = NumberFormat('#,##0.00', 'bs');
  static final NumberFormat _decimal = NumberFormat('#,##0.0', 'bs');

  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'Maj', 'Jun', 'Jul', 'Aug', 'Sep', 'Okt', 'Nov', 'Dec'];

  static String money(num value) => '${_money.format(value)} KM';

  static String decimal(num value) => _decimal.format(value);

  static String date(DateTime value) => DateFormat('dd.MM.yyyy.', 'bs').format(value.toLocal());

  static String dateTime(DateTime value) => DateFormat('dd.MM.yyyy. HH:mm', 'bs').format(value.toLocal());

  static String monthShort(int month) => _months[month - 1];
}
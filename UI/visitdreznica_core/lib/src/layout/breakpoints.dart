import 'package:flutter/widgets.dart';

/// Zajedničke granice širine za prilagođavanje rasporeda.
abstract final class Breakpoints {
  /// Ispod ovoga: telefon / vrlo uzak prozor.
  static const double compact = 600;

  /// Ispod ovoga: tablet / srednji prozor.
  static const double medium = 1000;

  /// Ispod ovoga: manji desktop prozor.
  static const double expanded = 1300;

  static bool isCompact(BuildContext context) => MediaQuery.sizeOf(context).width < compact;

  static bool isMedium(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= compact && width < medium;
  }

  /// Broj kolona za mrežu kartica, prema dostupnoj širini i najmanjoj širini kartice.
  static int columns(double width, {double minItemWidth = 320, int max = 4}) =>
      (width / minItemWidth).floor().clamp(1, max);
}

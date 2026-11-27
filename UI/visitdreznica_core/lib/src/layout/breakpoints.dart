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

  /// Razmak za listu/formu koja na širokom ekranu ostaje uska i centrirana.
  static EdgeInsets centered(BuildContext context, {double maxWidth = 600, double padding = 20}) {
    final width = MediaQuery.sizeOf(context).width;
    final side = width > maxWidth + 2 * padding ? (width - maxWidth) / 2 : padding;
    return EdgeInsets.symmetric(horizontal: side, vertical: padding);
  }

  /// Broj kolona za mrežu kartica, prema dostupnoj širini i najmanjoj širini kartice.
  static int columns(double width, {double minItemWidth = 320, int max = 4}) =>
      (width / minItemWidth).floor().clamp(1, max);
}

/// Ograničava širinu sadržaja (forme, detalji) na širokim ekranima i centrira ga.
class ContentWidth extends StatelessWidget {
  const ContentWidth({super.key, this.maxWidth = 560, required this.child});

  final double maxWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(constraints: BoxConstraints(maxWidth: maxWidth), child: child),
      );
}

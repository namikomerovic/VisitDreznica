import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'locale_controller.dart';

/// Izbor jezika (BS / EN) kao segmentirano dugme.
class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key, this.compact = false});

  /// Kratke oznake (BS / EN), npr. na ekranu prijave.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LocaleController>();

    return SegmentedButton<String>(
      showSelectedIcon: false,
      segments: [
        ButtonSegment(value: 'bs', label: Text(compact ? 'BS' : tr.languageBosnian)),
        ButtonSegment(value: 'en', label: Text(compact ? 'EN' : tr.languageEnglish)),
      ],
      selected: {controller.locale.languageCode},
      onSelectionChanged: (selection) => controller.setLocale(Locale(selection.first)),
    );
  }
}

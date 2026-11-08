import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme_controller.dart';

class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({super.key});

   @override
  Widget build(BuildContext context) {
    final controller = context.watch<ThemeController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final showIcons = constraints.maxWidth >= 420;

        return SegmentedButton<ThemeMode>(
          showSelectedIcon: false,
          segments: [
            ButtonSegment(
              value: ThemeMode.system,
              icon: showIcons ? const Icon(Icons.brightness_auto_outlined) : null,
              label: const Text('Sistem'),
            ),
            ButtonSegment(
              value: ThemeMode.light,
              icon: showIcons ? const Icon(Icons.light_mode_outlined) : null,
              label: const Text('Svijetla'),
            ),
            ButtonSegment(
              value: ThemeMode.dark,
              icon: showIcons ? const Icon(Icons.dark_mode_outlined) : null,
              label: const Text('Tamna'),
            ),
          ],
          selected: {controller.mode},
          onSelectionChanged: (selection) => controller.setMode(selection.first),
        );
      },
    );
  }
}
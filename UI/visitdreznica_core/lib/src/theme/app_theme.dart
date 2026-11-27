import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppFonts {
  static const sans = 'packages/visitdreznica_core/DMSans';
  static const serif = 'packages/visitdreznica_core/Fraunces';
}

abstract final class AppTheme {
  static ThemeData light() => _build(_lightScheme());

  static ThemeData dark() => _build(_darkScheme());

  static ColorScheme _lightScheme() => ColorScheme.fromSeed(
        seedColor: AppColors.forest,
        brightness: Brightness.light,
      ).copyWith(
        primary: AppColors.forest,
        onPrimary: Colors.white,
        primaryContainer: AppColors.forestSoft,
        onPrimaryContainer: AppColors.forest,
        secondary: AppColors.sage,
        onSecondary: Colors.white,
        secondaryContainer: AppColors.forestSoft,
        onSecondaryContainer: AppColors.forest,
        tertiary: AppColors.terracotta,
        onTertiary: Colors.white,
        tertiaryContainer: AppColors.terracottaSoft,
        onTertiaryContainer: const Color(0xFF7A2E14),
        surface: AppColors.cream,
        onSurface: AppColors.ink,
        onSurfaceVariant: AppColors.muted,
        surfaceContainerLowest: Colors.white,
        surfaceContainerLow: Colors.white,
        surfaceContainer: const Color(0xFFF1EEE6),
        surfaceContainerHigh: const Color(0xFFECE8DF),
        surfaceContainerHighest: const Color(0xFFE6E2D8),
        outline: const Color(0xFFB9B5AA),
        outlineVariant: AppColors.sand,
      );

  static ColorScheme _darkScheme() => ColorScheme.fromSeed(
        seedColor: AppColors.forest,
        brightness: Brightness.dark,
      ).copyWith(
        primary: AppColors.nightForest,
        onPrimary: AppColors.forestDeep,
        primaryContainer: const Color(0xFF2A4A3A),
        onPrimaryContainer: const Color(0xFFD5E8DB),
        secondaryContainer: const Color(0xFF2A4A3A),
        onSecondaryContainer: const Color(0xFFD5E8DB),
        tertiary: AppColors.nightTerracotta,
        tertiaryContainer: const Color(0xFF5A2A18),
        onTertiaryContainer: const Color(0xFFFFDBCC),
        surface: AppColors.nightBackground,
        surfaceContainerLowest: AppColors.nightSurface,
        surfaceContainerLow: AppColors.nightCard,
        surfaceContainer: const Color(0xFF232D28),
        surfaceContainerHigh: const Color(0xFF29342E),
        surfaceContainerHighest: const Color(0xFF303C35),
        outlineVariant: const Color(0xFF2F3A34),
      );

  static ThemeData _build(ColorScheme scheme) {
    final base = ThemeData(useMaterial3: true, brightness: scheme.brightness).textTheme.apply(
          fontFamily: AppFonts.sans,
          bodyColor: scheme.onSurface,
          displayColor: scheme.onSurface,
        );

    TextStyle? serif(TextStyle? style) => style?.copyWith(fontFamily: AppFonts.serif, fontWeight: FontWeight.w600);

    final textTheme = base.copyWith(
      displayLarge: serif(base.displayLarge),
      displayMedium: serif(base.displayMedium),
      displaySmall: serif(base.displaySmall),
      headlineLarge: serif(base.headlineLarge),
      headlineMedium: serif(base.headlineMedium),
      headlineSmall: serif(base.headlineSmall),
      titleLarge: serif(base.titleLarge),
      titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );

    final rounded12 = RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: AppFonts.sans,
      textTheme: textTheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: rounded12,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: rounded12,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          side: BorderSide(color: scheme.outlineVariant),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(shape: rounded12, textStyle: textTheme.labelLarge),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLowest,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide(color: scheme.outlineVariant),
        backgroundColor: scheme.surfaceContainerLowest,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: scheme.primaryContainer,
          selectedForegroundColor: scheme.onPrimaryContainer,
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        indicatorColor: scheme.primaryContainer,
        elevation: 0,
        height: 68,
        labelTextStyle: WidgetStatePropertyAll(
          textTheme.labelSmall?.copyWith(fontSize: 11.5, fontWeight: FontWeight.w500, letterSpacing: 0),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: scheme.surfaceContainerLowest),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    );
  }
}

import 'package:flutter/material.dart';

/// "Aurora Academia" theme — dark by default.
///
/// Primary: indigo `#6366F1` · Secondary: teal `#14B8A6` · Accent: amber `#F59E0B`.
abstract final class AppTheme {
  static const Color primary = Color(0xFF6366F1); // indigo
  static const Color secondary = Color(0xFF14B8A6); // teal
  static const Color accent = Color(0xFFF59E0B); // amber

  static ThemeData dark() => _base(Brightness.dark);
  static ThemeData light() => _base(Brightness.light);

  static ThemeData _base(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
      secondary: secondary,
      tertiary: accent,
    ).copyWith(
      surface: isDark ? const Color(0xFF0F1020) : const Color(0xFFF7F7FB),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        centerTitle: true,
        elevation: 0,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import 'tokens.dart';

/// Тема приложения.
///
/// Раньше в MaterialApp стоял голый `ThemeData()`, а каждый экран красил себя
/// сам через глобальные переменные и `GoogleFonts.roboto(...)`. Отсюда и
/// разнобой: одинаковые по смыслу кнопки выглядели по-разному на разных экранах.
///
/// Шрифт намеренно системный: на iOS это SF Pro, на Android — Roboto. Так
/// интерфейс ощущается родным на обеих платформах, и заодно уходит загрузка
/// шрифтов по сети, которую делал google_fonts.
class MtTheme {
  const MtTheme._();

  static String? get _fontFamily {
    // null = системный шрифт платформы (SF Pro / Roboto).
    return null;
  }

  /// На iOS базовый кегль текста — 17pt. Держим эту шкалу на обеих платформах,
  /// чтобы вёрстка не расходилась.
  static TextTheme _textTheme(Color ink, Color inkMuted) {
    return TextTheme(
      displaySmall: TextStyle(
        fontSize: 34,
        height: 40 / 34,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: ink,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        height: 34 / 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: ink,
      ),
      headlineSmall: TextStyle(
        fontSize: 22,
        height: 28 / 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: ink,
      ),
      titleLarge: TextStyle(
        fontSize: 19,
        height: 24 / 19,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      titleMedium: TextStyle(
        fontSize: 17,
        height: 22 / 17,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      bodyLarge: TextStyle(
        fontSize: 17,
        height: 24 / 17,
        fontWeight: FontWeight.w400,
        color: ink,
      ),
      bodyMedium: TextStyle(
        fontSize: 15,
        height: 20 / 15,
        fontWeight: FontWeight.w400,
        color: ink,
      ),
      bodySmall: TextStyle(
        fontSize: 13,
        height: 18 / 13,
        fontWeight: FontWeight.w400,
        color: inkMuted,
      ),
      labelLarge: TextStyle(
        fontSize: 17,
        height: 22 / 17,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      labelMedium: TextStyle(
        fontSize: 13,
        height: 16 / 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: inkMuted,
      ),
    );
  }

  static ThemeData light() {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: MtColors.brand400,
      onPrimary: MtColors.neutral900,
      primaryContainer: MtColors.brand100,
      onPrimaryContainer: MtColors.brand700,
      secondary: MtColors.neutral800,
      onSecondary: MtColors.neutral0,
      secondaryContainer: MtColors.neutral100,
      onSecondaryContainer: MtColors.neutral800,
      error: MtColors.danger,
      onError: MtColors.neutral0,
      errorContainer: MtColors.dangerSoft,
      onErrorContainer: MtColors.danger,
      surface: MtColors.neutral0,
      onSurface: MtColors.neutral900,
      surfaceContainerLowest: MtColors.neutral0,
      surfaceContainerLow: MtColors.neutral50,
      surfaceContainer: MtColors.neutral100,
      surfaceContainerHigh: MtColors.neutral200,
      onSurfaceVariant: MtColors.neutral500,
      outline: MtColors.neutral300,
      outlineVariant: MtColors.neutral200,
      inverseSurface: MtColors.neutral900,
      onInverseSurface: MtColors.neutral0,
    );
    return _base(scheme, MtColors.neutral900, MtColors.neutral500);
  }

  static ThemeData dark() {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: MtColors.brand400,
      onPrimary: MtColors.neutral950,
      primaryContainer: Color(0xFF3A2C10),
      onPrimaryContainer: MtColors.brand300,
      secondary: MtColors.neutral100,
      onSecondary: MtColors.neutral900,
      secondaryContainer: Color(0xFF2A2825),
      onSecondaryContainer: MtColors.neutral100,
      error: Color(0xFFF08278),
      onError: MtColors.neutral950,
      errorContainer: Color(0xFF3A1B18),
      onErrorContainer: Color(0xFFF08278),
      surface: Color(0xFF171614),
      onSurface: Color(0xFFEDECE8),
      surfaceContainerLowest: Color(0xFF0F0E0D),
      surfaceContainerLow: Color(0xFF1C1B19),
      surfaceContainer: Color(0xFF232220),
      surfaceContainerHigh: Color(0xFF2C2A28),
      onSurfaceVariant: Color(0xFF9E9A92),
      outline: Color(0xFF403E3A),
      outlineVariant: Color(0xFF2C2A28),
      inverseSurface: MtColors.neutral50,
      onInverseSurface: MtColors.neutral900,
    );
    return _base(scheme, const Color(0xFFEDECE8), const Color(0xFF9E9A92));
  }

  static ThemeData _base(ColorScheme scheme, Color ink, Color inkMuted) {
    final text = _textTheme(ink, inkMuted);
    final isDark = scheme.brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: _fontFamily,
      textTheme: text,
      // На тон глубже, чем поверхности: белые поля и карточки должны
      // отделяться от подложки. При surfaceContainerLow разница составляла
      // два процента яркости и поля визуально сливались с фоном.
      scaffoldBackgroundColor: scheme.surfaceContainer,
      splashFactory:
          Platform.isIOS ? NoSplash.splashFactory : InkSparkle.splashFactory,

      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: true,
        titleTextStyle: text.titleMedium,
      ),

      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          disabledBackgroundColor: isDark
              ? const Color(0xFF2C2A28)
              : MtColors.neutral200,
          disabledForegroundColor: scheme.onSurfaceVariant,
          minimumSize: const Size.fromHeight(MtSize.control),
          shape: const RoundedRectangleBorder(borderRadius: MtRadius.brLg),
          textStyle: text.labelLarge,
          elevation: 0,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          minimumSize: const Size.fromHeight(MtSize.control),
          side: BorderSide(color: scheme.outline),
          shape: const RoundedRectangleBorder(borderRadius: MtRadius.brLg),
          textStyle: text.labelLarge,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: isDark ? MtColors.brand300 : MtColors.brand600,
          minimumSize: const Size(MtSize.minTouch, MtSize.minTouch),
          textStyle: text.labelLarge,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        // Поля светлее подложки экрана, иначе сливаются с ней.
        fillColor: scheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: MtSpace.lg,
          vertical: MtSpace.lg,
        ),
        hintStyle: text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
        border: OutlineInputBorder(
          borderRadius: MtRadius.brLg,
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: MtRadius.brLg,
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: MtRadius.brLg,
          borderSide: BorderSide(color: MtColors.brand400, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: MtRadius.brLg,
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: MtRadius.brLg,
          borderSide: BorderSide(color: scheme.error, width: 2),
        ),
      ),

      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: MtRadius.brXl),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: MtRadius.sheet),
        showDragHandle: true,
        dragHandleColor: scheme.outline,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: text.bodyMedium?.copyWith(
          color: scheme.onInverseSurface,
        ),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: MtRadius.brMd),
      ),

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
        },
      ),
    );
  }
}

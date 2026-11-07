import 'package:flutter/material.dart';
import 'package:my_farm/core/theme/app_colors.dart';

/// Typography scale for myFarm.
///
/// Built from a base text size of 16sp with a modular scale.
/// Arabic uses Noto Naskh Arabic; French uses the default system
/// font (or a shared sans-serif). Both are applied via fontFamily
/// overrides when the locale changes.
class AppTypography {
  AppTypography._();

  static const String _fontFamily = 'System';
  static const String _fontFamilyArabic = 'NotoNaskhArabic';

  static TextTheme _buildTextTheme(Color onSurface, Color secondary) =>
      TextTheme(
        displayLarge: TextStyle(
          fontSize: 57,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.25,
          color: onSurface,
          fontFamily: _fontFamily,
        ),
        displayMedium: TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          color: onSurface,
          fontFamily: _fontFamily,
        ),
        displaySmall: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          color: onSurface,
          fontFamily: _fontFamily,
        ),
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: onSurface,
          fontFamily: _fontFamily,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: onSurface,
          fontFamily: _fontFamily,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: onSurface,
          fontFamily: _fontFamily,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
          color: onSurface,
          fontFamily: _fontFamily,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
          color: onSurface,
          fontFamily: _fontFamily,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          color: onSurface,
          fontFamily: _fontFamily,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          color: onSurface,
          fontFamily: _fontFamily,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          color: onSurface,
          fontFamily: _fontFamily,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          color: secondary,
          fontFamily: _fontFamily,
          height: 1.5,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          color: onSurface,
          fontFamily: _fontFamily,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          color: onSurface,
          fontFamily: _fontFamily,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          color: secondary,
          fontFamily: _fontFamily,
        ),
      );

  static TextTheme get lightTextTheme =>
      _buildTextTheme(AppColors.primaryTextLight, AppColors.secondaryTextLight);

  static TextTheme get darkTextTheme =>
      _buildTextTheme(AppColors.primaryTextDark, AppColors.secondaryTextDark);

  /// Returns the font family to use for the current locale.
  static String fontFamilyForLocale(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return _fontFamilyArabic;
      default:
        return _fontFamily;
    }
  }
}

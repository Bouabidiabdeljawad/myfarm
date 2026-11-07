import 'package:flutter/material.dart';

/// Semantic color tokens for myFarm.
///
/// Primitive values → semantic aliases → component overrides.
/// Light and dark variants are provided so `ThemeMode.system` works
/// seamlessly with Material 3.
class AppColors {
  AppColors._();

  // ── Primitive palette ──
  static const Color olive50 = Color(0xFFF7F9F2);
  static const Color olive100 = Color(0xF0F4E8);
  static const Color olive200 = Color(0xE0EBD2);
  static const Color olive300 = Color(0xCBDD9F);
  static const Color olive400 = Color(0xB7CF7D);
  static const Color olive500 = Color(0x8A9A3D); // primary base
  static const Color olive600 = Color(0x6E7C33);
  static const Color olive700 = Color(0x525F28);
  static const Color olive800 = Color(0x3A441E);
  static const Color olive900 = Color(0x232B13);

  static const Color beige50 = Color(0xFFFBF9F4);
  static const Color beige100 = Color(0xFFF5F0E9);
  static const Color beige200 = Color(0xFFEDE1CB);
  static const Color beige300 = Color(0xFFE4D3B2);
  static const Color beige400 = Color(0xFFDBC499);
  static const Color beige500 = Color(0xFFD2B580);

  static const Color forestGreen50 = Color(0xFFF0F3EE);
  static const Color forestGreen100 = Color(0xFFE0E7E4);
  static const Color forestGreen200 = Color(0xFFC3CEC9);
  static const Color forestGreen300 = Color(0xFFA6B6AE);
  static const Color forestGreen400 = Color(0xFF8A9D95);
  static const Color forestGreen500 = Color(0x1E2A24); // dark forest green base

  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFEEEEEE);
  static const Color neutral300 = Color(0xFFDDDDDD);
  static const Color neutral400 = Color(0xFFBBBBBB);
  static const Color neutral500 = Color(0xFF9E9E9E);
  static const Color neutral600 = Color(0xFF757575);
  static const Color neutral700 = Color(0xFF616161);
  static const Color neutral800 = Color(0xFF424242);
  static const Color neutral900 = Color(0xFF212121);

  static const Color white = Color(0xFFFFFFFF);

  static const Color warning500 = Color(0xFFF59E0B); // amber
  static const Color error500 = Color(0xFFEF4444);   // red
  static const Color success500 = Color(0xFF10B981); // emerald
  static const Color info500 = Color(0xFF3B82F6);    // blue

  // ── Semantic: light theme ──
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.olive500,
    onPrimary: AppColors.white,
    primaryContainer: AppColors.olive100,
    onPrimaryContainer: AppColors.olive900,
    secondary: AppColors.forestGreen500,
    onSecondary: AppColors.white,
    secondaryContainer: AppColors.forestGreen100,
    onSecondaryContainer: AppColors.forestGreen500,
    tertiary: AppColors.beige500,
    onTertiary: AppColors.white,
    error: AppColors.error500,
    onError: AppColors.white,
    background: AppColors.beige50,
    onBackground: AppColors.neutral800,
    surface: AppColors.white,
    onSurface: AppColors.neutral800,
    surfaceVariant: AppColors.olive100,
    onSurfaceVariant: AppColors.neutral600,
    outline: AppColors.neutral300,
    outlineVariant: AppColors.neutral200,
    shadow: AppColors.neutral900,
    scrim: AppColors.neutral900,
    inverseSurface: AppColors.neutral800,
    onInverseSurface: AppColors.white,
    inversePrimary: AppColors.olive700,
  );

  // ── Semantic: dark theme ──
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.olive400,
    onPrimary: AppColors.olive900,
    primaryContainer: AppColors.olive800,
    onPrimaryContainer: AppColors.olive100,
    secondary: AppColors.forestGreen400,
    onSecondary: AppColors.olive900,
    secondaryContainer: AppColors.neutral800,
    onSecondaryContainer: AppColors.forestGreen100,
    tertiary: AppColors.beige400,
    onTertiary: AppColors.white,
    error: AppColors.error500,
    onError: AppColors.white,
    background: AppColors.neutral900,
    onBackground: AppColors.neutral100,
    surface: AppColors.neutral800,
    onSurface: AppColors.neutral100,
    surfaceVariant: AppColors.neutral700,
    onSurfaceVariant: AppColors.neutral300,
    outline: AppColors.neutral600,
    outlineVariant: AppColors.neutral700,
    shadow: AppColors.black,
    scrim: AppColors.black,
    inverseSurface: AppColors.neutral100,
    onInverseSurface: AppColors.black,
    inversePrimary: AppColors.olive300,
  );

  // ── Derived semantic tokens ──
  static const Color surfaceLight = AppColors.white;
  static const Color surfaceDark = AppColors.neutral800;

  static const Color cardLight = AppColors.white;
  static const Color cardDark = AppColors.neutral800;

  static const Color black = Color(0xFF000000);

  static const Color primaryTextLight = AppColors.neutral800;
  static const Color primaryTextDark = AppColors.neutral100;

  static const Color secondaryTextLight = AppColors.neutral600;
  static const Color secondaryTextDark = AppColors.neutral400;

  static const Color dividerLight = AppColors.neutral200;
  static const Color dividerDark = AppColors.neutral700;
}

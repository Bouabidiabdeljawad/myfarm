import 'package:flutter/material.dart';
import 'package:my_farm/core/theme/app_colors.dart';
import 'package:my_farm/core/theme/app_spacing.dart';

/// Component-level theme overrides shared across features.
///
/// These are applied through Material 3 theme extension points
/// (elevatedButtonTheme, inputDecorationTheme, etc.) so every
/// button/input/card in the app uses the myFarm design language
/// without duplicating styling code.
class AppComponents {
  AppComponents._();

  // ── Button styles ──
  static const ButtonStyle _elevatedButtonStyle = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(AppColors.olive500),
    foregroundColor: WidgetStatePropertyAll(AppColors.white),
    minimumSize: WidgetStatePropertyAll(Size.fromHeight(AppSpacing.buttonHeight)),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppSpacing.buttonBorderRadius)),
      ),
    ),
    elevation: WidgetStatePropertyAll(0),
  );

  static const ButtonStyle _filledButtonStyle = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(AppColors.olive500),
    foregroundColor: WidgetStatePropertyAll(AppColors.white),
    minimumSize: WidgetStatePropertyAll(Size.fromHeight(AppSpacing.buttonHeight)),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppSpacing.buttonBorderRadius)),
      ),
    ),
    elevation: WidgetStatePropertyAll(0),
  );

  static const ButtonStyle _outlinedButtonStyle = ButtonStyle(
    foregroundColor: WidgetStatePropertyAll(AppColors.olive500),
    side: WidgetStatePropertyAll(BorderSide(color: AppColors.olive500, width: 1.5)),
    minimumSize: WidgetStatePropertyAll(Size.fromHeight(AppSpacing.buttonHeight)),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppSpacing.buttonBorderRadius)),
      ),
    ),
  );

  static const ButtonStyle _textButtonStyle = ButtonStyle(
    foregroundColor: WidgetStatePropertyAll(AppColors.olive500),
    minimumSize: WidgetStatePropertyAll(Size.fromHeight(AppSpacing.buttonHeightSmall)),
  );

  // ── Input decoration ──
  static InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
        filled: true,
        fillColor: AppColors.neutral100,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.lg,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppSpacing.inputBorderRadius)),
          borderSide: BorderSide(color: AppColors.neutral300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppSpacing.inputBorderRadius)),
          borderSide: BorderSide(color: AppColors.neutral300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppSpacing.inputBorderRadius)),
          borderSide: BorderSide(color: AppColors.olive500, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppSpacing.inputBorderRadius)),
          borderSide: BorderSide(color: AppColors.error500),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppSpacing.inputBorderRadius)),
          borderSide: BorderSide(color: AppColors.error500, width: 2.0),
        ),
        labelStyle: TextStyle(
          color: AppColors.neutral600,
          fontSize: AppSpacing.base * 3.5, // 14sp
        ),
        hintStyle: TextStyle(
          color: AppColors.neutral400,
          fontSize: AppSpacing.base * 3.5,
        ),
        errorStyle: TextStyle(
          color: AppColors.error500,
          fontSize: AppSpacing.base * 3, // 12sp
        ),
      );

  // ── Card theme ──
  static CardThemeData get cardTheme => CardThemeData(
        color: AppColors.cardLight,
        elevation: 1,
        shadowColor: AppColors.black.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppSpacing.cardBorderRadius)),
        ),
        margin: EdgeInsets.zero,
      );

  // ── Material 3 theme data extensions ──
  static ElevatedButtonThemeData get elevatedButtonTheme =>
      ElevatedButtonThemeData(style: _elevatedButtonStyle);

  static FilledButtonThemeData get filledButtonTheme =>
      FilledButtonThemeData(style: _filledButtonStyle);

  static OutlinedButtonThemeData get outlinedButtonTheme =>
      OutlinedButtonThemeData(style: _outlinedButtonStyle);

  static TextButtonThemeData get textButtonTheme =>
      TextButtonThemeData(style: _textButtonStyle);
}

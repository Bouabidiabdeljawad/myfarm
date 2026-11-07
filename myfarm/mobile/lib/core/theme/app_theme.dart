import 'package:flutter/material.dart';
import 'package:my_farm/core/theme/app_colors.dart';
import 'package:my_farm/core/theme/app_typography.dart';
import 'package:my_farm/core/theme/app_spacing.dart';
import 'package:my_farm/core/theme/app_components.dart';

/// Central theme definition for myFarm.
///
/// Provides Material 3 light and dark themes built from semantic
/// color tokens. Consumed by [MyApp] via `AppTheme.lightTheme` /
/// `AppTheme.darkTheme`.
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: AppColors.lightColorScheme,
        textTheme: AppTypography.lightTextTheme,
        scaffoldBackgroundColor: AppColors.surfaceLight,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 1,
        ),
        elevatedButtonTheme: AppComponents.elevatedButtonTheme,
        filledButtonTheme: AppComponents.filledButtonTheme,
        outlinedButtonTheme: AppComponents.outlinedButtonTheme,
        textButtonTheme: AppComponents.textButtonTheme,
        inputDecorationTheme: AppComponents.inputDecorationTheme,
        cardTheme: AppComponents.cardTheme,
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: AppColors.darkColorScheme,
        textTheme: AppTypography.darkTextTheme,
        scaffoldBackgroundColor: AppColors.surfaceDark,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 1,
        ),
        elevatedButtonTheme: AppComponents.elevatedButtonTheme,
        filledButtonTheme: AppComponents.filledButtonTheme,
        outlinedButtonTheme: AppComponents.outlinedButtonTheme,
        textButtonTheme: AppComponents.textButtonTheme,
        inputDecorationTheme: AppComponents.inputDecorationTheme,
        cardTheme: AppComponents.cardTheme,
      );
}

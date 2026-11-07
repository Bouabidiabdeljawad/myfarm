import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Localizations for the myFarm app.
///
/// ARB files live alongside this file:
///   - app_en.arb (fallback, English)
///   - app_ar.arb  (Arabic, RTL)
///   - app_fr.arb  (French, LTR)
///
/// Generated with: `flutter gen-l10n`
class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // --- Fallback strings (English). Replace with generated getters
  //     once `flutter gen-l10n` has run against the ARB files. ---

  String get appTitle => 'myFarm';

  String get errorNetwork => 'No internet connection. Please try again.';
  String get errorServer => 'Server error. Please try again later.';
  String get errorAuth => 'Authentication failed.';
  String get errorDatabase => 'Database error.';
  String get errorSecureStorage => 'Secure storage error.';
  String get errorValidation => 'Validation error.';
  String get errorUnknown => 'An unexpected error occurred.';
  String get errorRequestCancelled => 'Request was cancelled.';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'fr', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

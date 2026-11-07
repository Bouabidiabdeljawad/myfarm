import 'package:flutter/material.dart';

/// Spacing and sizing tokens for myFarm.
///
/// Based on a 4px base grid. All padding, margin, gap, and size
/// values derive from this scale so layouts stay consistent.
class AppSpacing {
  AppSpacing._();

  static const double base = 4.0;

  // ── Spacing scale ──
  static const double xs = 4.0;   // 1 * base
  static const double sm = 8.0;   // 2 * base
  static const double md = 12.0;  // 3 * base
  static const double lg = 16.0;  // 4 * base
  static const double xl = 20.0;  // 5 * base
  static const double xxl = 24.0; // 6 * base
  static const double xxxl = 32.0; // 8 * base

  // ── Component sizing ──
  static const double buttonHeight = 48.0;
  static const double buttonHeightSmall = 36.0;
  static const double buttonHeightLarge = 56.0;
  static const double iconSizeSm = 16.0;
  static const double iconSizeMd = 20.0;
  static const double iconSizeLg = 24.0;
  static const double avatarSizeSm = 32.0;
  static const double avatarSizeMd = 40.0;
  static const double avatarSizeLg = 48.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double cardBorderRadius = 12.0;
  static const double buttonBorderRadius = 10.0;
  static const double inputBorderRadius = 10.0;
  static const double sheetBorderRadius = 16.0;
  static const double dialogBorderRadius = 16.0;

  /// EdgeInsets helpers for common padding combinations.
  static EdgeInsets get paddingAllXS => EdgeInsets.all(xs);
  static EdgeInsets get paddingAllSM => EdgeInsets.all(sm);
  static EdgeInsets get paddingAllMD => EdgeInsets.all(md);
  static EdgeInsets get paddingAllLG => EdgeInsets.all(lg);
  static EdgeInsets get paddingAllXL => EdgeInsets.all(xl);
  static EdgeInsets get paddingHorizontalMD => EdgeInsets.symmetric(horizontal: md);
  static EdgeInsets get paddingHorizontalLG => EdgeInsets.symmetric(horizontal: lg);
  static EdgeInsets get paddingHorizontalXL => EdgeInsets.symmetric(horizontal: xl);
  static EdgeInsets get paddingVerticalMD => EdgeInsets.symmetric(vertical: md);
  static EdgeInsets get paddingVerticalLG => EdgeInsets.symmetric(vertical: lg);
  static EdgeInsets get paddingScreen => EdgeInsets.all(lg);
}

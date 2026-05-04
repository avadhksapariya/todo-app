import 'package:flutter/material.dart';

class AppColors {
  // Base
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color transparent = Colors.transparent;

  // Primary Brand
  static const Color primary = Color(0xFF2564CF);

  // Backgrounds
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;

  // Text
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.grey;

  // Grey Variants
  static Color greyLight = Colors.grey.shade300;
  static Color greyLighter = Colors.grey.shade400;

  // Status
  static const Color error = Colors.red;

  // Derived Colors
  static Color primaryLight = primary.withValues(alpha: 0.1);
}

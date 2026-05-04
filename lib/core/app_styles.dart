import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppStyles {
  static final InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );

  static final FilledButtonThemeData filledButtonTheme = FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.primary,
      minimumSize: const Size(0, 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );

  static final CardThemeData cardTheme = CardThemeData(
    color: AppColors.white,
    surfaceTintColor: AppColors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );
}

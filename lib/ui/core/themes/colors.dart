import 'package:flutter/material.dart';

abstract final class AppColors {
  static const amber1 = Color(0xFFFFC107);
  static const amber2 = Color(0xFFFFE082);

  static const grey1 = Color(0xFF212121);
  static const grey2 = Color(0xFFBDBDBD);
  static const grey3 = Color(0xFFEEEEEE);
  static const grey4 = Color(0xFFF5F5F5);

  static const trans = Color(0x00000000);
  static const white = Color(0xFFFFFFFF);

  static const lightColorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.amber1,
      onPrimary: AppColors.white,
      secondary: AppColors.white,
      onSecondary: AppColors.grey1,
      surface: AppColors.white,
      onSurface: AppColors.grey2,
      error: AppColors.white,
      onError: Color(0xFFF44336));
}

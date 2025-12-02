import 'package:flutter/material.dart';

import 'package:codes_postaux/ui/core/themes/colors.dart';
import 'package:codes_postaux/ui/core/themes/styles.dart';

abstract final class AppTheme {
  static const OutlineInputBorder borderTextField = .new(
    borderRadius: .all(.circular(10)),
    borderSide: .new(style: .none),
  );

  static ThemeData lightTheme = .new(
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.amber1,
      titleTextStyle: AppStyles.header,
    ),
    brightness: .light,
    colorScheme: AppColors.lightColorScheme,
    floatingActionButtonTheme: const .new(
      elevation: 0,
      disabledElevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
    ),
    hoverColor: AppColors.trans,
    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: .fromLTRB(6, 0, 0, 0),
      enabledBorder: borderTextField,
      fillColor: AppColors.white,
      filled: true,
      focusedBorder: borderTextField,
      hintStyle: AppStyles.hint,
      suffixIconColor: AppColors.amber1,
    ),
    snackBarTheme: const .new(
      backgroundColor: AppColors.amber1,
      contentTextStyle: AppStyles.textSecondary,
    ),
    tooltipTheme: .new(
      decoration: BoxDecoration(
        borderRadius: .circular(5),
        color: AppColors.white,
      ),
      textStyle: AppStyles.tooltip,
    ),
  );
}

import 'package:flutter/material.dart';

import 'package:codes_postaux/ui/core/themes/colors.dart';
import 'package:codes_postaux/ui/core/themes/dimens.dart';
import 'package:codes_postaux/ui/core/themes/styles.dart';

abstract final class AppTheme {
  static const OutlineInputBorder borderTextField = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(style: BorderStyle.none));

  static ThemeData lightTheme = ThemeData(
      appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.amber1, titleTextStyle: AppStyles.header),
      brightness: Brightness.light,
      colorScheme: AppColors.lightColorScheme,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          elevation: 0,
          disabledElevation: 0,
          highlightElevation: 0,
          hoverElevation: 0),
      hoverColor: AppColors.trans,
      inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: borderTextField,
          enabledBorder: borderTextField,
          contentPadding: Dimens.textFieldContent,
          fillColor: AppColors.white,
          filled: true,
          hintStyle: AppStyles.hint,
          suffixIconColor: AppColors.amber1),
      snackBarTheme: const SnackBarThemeData(
          backgroundColor: AppColors.amber1,
          contentTextStyle: AppStyles.textSecondary),
      tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: AppColors.white),
          textStyle: AppStyles.tooltip));
}

import 'package:flutter/material.dart';

const Color primaryColor = Colors.amber;
const Color secondaryColor = Colors.white;

//

BorderRadius borderRadius = BorderRadius.circular(10);

final OutlineInputBorder borderTextField = OutlineInputBorder(
    borderRadius: borderRadius,
    borderSide: const BorderSide(style: BorderStyle.none));

const TextStyle styleAutoSizeText =
    TextStyle(color: secondaryColor, fontSize: 16);

//

ThemeData get theme => ThemeData(
    appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        titleTextStyle: TextStyle(fontSize: 18, color: secondaryColor)),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        elevation: 0,
        disabledElevation: 0,
        foregroundColor: secondaryColor,
        highlightElevation: 0,
        hoverElevation: 0),
    hoverColor: Colors.transparent,
    inputDecorationTheme: InputDecorationTheme(
        focusedBorder: borderTextField,
        enabledBorder: borderTextField,
        contentPadding: const EdgeInsets.all(10),
        fillColor: secondaryColor,
        filled: true,
        hintStyle: TextStyle(color: Colors.black.withAlpha(127)),
        suffixIconColor: primaryColor),
    textSelectionTheme: const TextSelectionThemeData(
        selectionColor: primaryColor, cursorColor: primaryColor),
    tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: secondaryColor),
        textStyle: const TextStyle(color: primaryColor, fontSize: 12)));

import 'package:flutter/material.dart';

abstract final class Dimens {
  static const paddingHorizontal = 10.0;

  static const paddingVertical = 10.0;

  static const itemHeight = 40.0;

  static const toolbarHeight = 60.0;

  static const textFieldContent = EdgeInsets.only(left: 10);

  static const edgeInsetsScreenSymmetric = EdgeInsets.symmetric(
    horizontal: paddingHorizontal,
    vertical: paddingVertical,
  );
}

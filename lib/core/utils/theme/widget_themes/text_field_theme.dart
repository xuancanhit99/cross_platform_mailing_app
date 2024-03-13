import 'package:flutter/material.dart';

import '../../../constants/colors.dart';


class CTextFormFieldTheme {
  CTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
      prefixIconColor: cSecondaryColor,
      floatingLabelStyle: const TextStyle(color: cSecondaryColor),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100),
        borderSide: const BorderSide(width: 2, color: cSecondaryColor),
      ));

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
      prefixIconColor: cPrimaryColor,
      floatingLabelStyle: const TextStyle(color: cPrimaryColor),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100),
        borderSide: const BorderSide(width: 2, color: cPrimaryColor),
      ));
}

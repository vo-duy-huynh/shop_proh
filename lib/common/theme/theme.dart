import 'package:flutter/material.dart';
import 'package:shop_proh/constants/globalvariable.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: GlobalVariables.secondaryColor,
    background: GlobalVariables.backgroundColor,
    secondary: GlobalVariables.secondaryColor,
  ),
  scaffoldBackgroundColor: GlobalVariables.backgroundColor,
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: GlobalVariables.secondaryColor,
    background: Colors.blue.shade100,
    secondary: GlobalVariables.secondaryColor,
  ),
  scaffoldBackgroundColor: Colors.blue.shade100,
);

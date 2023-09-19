 
import 'package:flutter/material.dart';

import '../../theme/Pallete.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
    textTheme: TextTheme(
      bodyText1: TextStyle(),
      bodyText2: TextStyle(),
    ).apply(
      bodyColor: Pallete.textColor,
    ),
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: Pallete.backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Pallete.mainColor,
      shadowColor: Colors.green,
      elevation: 1,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Pallete.mainColor,
    ),
  );
}

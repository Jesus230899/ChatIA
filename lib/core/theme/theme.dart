import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class AppTheme {
  static ThemeData appTheme = ThemeData(
    textTheme: GoogleFonts.openSansTextTheme(),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primary,
    ),
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.primary,
      onSecondary: AppColors.primary,
      brightness: Brightness.light,
      error: Colors.red,
      onError: Colors.red,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
  );

}

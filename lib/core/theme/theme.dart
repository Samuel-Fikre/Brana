import 'package:flutter/material.dart';
import 'package:brana/core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppColors.background,
    textTheme: GoogleFonts.urbanistTextTheme(),
  );
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeLight {
  static final ThemeData theme = ThemeData(
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(
        color: Colors.white, // ← seta e todos os ícones da AppBar
      )
    ),
    textTheme: GoogleFonts.frauncesTextTheme(),
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff3C1E01),
      onPrimary: Colors.white,
      secondary: Colors.white,
      onSecondary: Color(0xff3C1E01),
      error: Colors.red,
      onError: Colors.white,
      surface: Colors.white,
      onSurface: Color(0xff3C1E01),
    )
  );
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeDark {
  static final ThemeData theme = ThemeData(
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(
        color: Colors.white, // ← seta e todos os ícones da AppBar
      )
    ),
    textTheme: GoogleFonts.frauncesTextTheme(),
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff3C1E01),
      onPrimary: Colors.white,
      secondary: Colors.black,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      surface: Colors.black,
      onSurface: Colors.white,
      
    )
  );
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextThemes {
  static TextTheme _buildTextTheme(TextTheme base) {
    final TextTheme body = GoogleFonts.merriweatherTextTheme(base);
    final TextTheme title = GoogleFonts.merriweatherSansTextTheme(base);

    return title.copyWith(
      bodyLarge: body.bodyLarge,
      bodyMedium: body.bodyMedium,
      bodySmall: body.bodySmall,
      headlineLarge: body.headlineLarge,
      headlineMedium: body.headlineMedium,
      headlineSmall: body.headlineSmall,
    );
  }

  static TextTheme light = _buildTextTheme(ThemeData.light().textTheme);
  static TextTheme dark = _buildTextTheme(ThemeData.dark().textTheme);
}

import 'package:flutter/material.dart';
import 'package:story_v1/themes/text_themes.dart';

import 'color_schemes.dart';

class AppThemes {
  static ThemeData light = ThemeData.from(
    useMaterial3: true,
    colorScheme: ColorSchemes.light,
    textTheme: TextThemes.light,
  );

  static ThemeData dark = ThemeData.from(
    useMaterial3: true,
    colorScheme: ColorSchemes.dark,
    textTheme: TextThemes.dark,
  );
}

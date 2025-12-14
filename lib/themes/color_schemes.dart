import 'package:flutter/material.dart';

const Color _kSeedColor = Colors.indigoAccent;

class ColorSchemes {
  static ColorScheme light = ColorScheme.fromSeed(
    seedColor: _kSeedColor,
    brightness: Brightness.light,
  );

  static ColorScheme dark = ColorScheme.fromSeed(
    seedColor: _kSeedColor,
    brightness: Brightness.dark,
  );
}

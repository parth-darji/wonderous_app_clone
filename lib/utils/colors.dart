import 'package:flutter/material.dart';

bool isDark = false;

/// use this class to apply theme colors
class AppColors {
  static Color accent1 = const Color(0xFFE4935D);
  static Color accent2 = const Color(0xFFBEABA1);
  static Color offWhite = const Color(0xFFF8ECE5);
  static Color caption = const Color(0xFF7D7873);
  static Color body = const Color(0xFF514F4D);
  static Color greyStrong = const Color(0xFF272625);
  static Color greyMedium = const Color(0xFF9D9995);
  static Color white = Colors.white;
  static Color black = const Color(0xFF1E1B18);

  static Color shift(Color c, double d) => shiftHsl(c, d * (isDark ? -1 : 1));

  static Color shiftHsl(Color c, [double amt = 0]) {
    var hslc = HSLColor.fromColor(c);
    return hslc.withLightness((hslc.lightness + amt).clamp(0.0, 1.0)).toColor();
  }
}

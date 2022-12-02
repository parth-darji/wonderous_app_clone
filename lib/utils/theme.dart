import 'package:flutter/material.dart';

import 'colors.dart';

/// used to override default flutter light theme configuration
ThemeData light() {
  return ThemeData.light().copyWith(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.white,
  );
}

/// used to override default flutter dark theme configuration
ThemeData dark() {
  return ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.black,
  );
}

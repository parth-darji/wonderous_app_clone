import 'package:flutter/material.dart';

import 'colors.dart';

/// used to override default flutter light theme configuration
ThemeData light() {
  return ThemeData.light().copyWith(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.white,
    textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Cinzel',
        ),
  );
}

/// used to override default flutter dark theme configuration
ThemeData dark() {
  return ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.black,
    textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'Cinzel',
        ),
  );
}

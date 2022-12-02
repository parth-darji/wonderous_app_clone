// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:wonderous_clone/utils/colors.dart';

export 'colors.dart';

AppStyle $styles = AppStyle();

@immutable
class AppStyle {
  AppStyle({Size? appSize}) {
    if (appSize == null) {
      scale = 1;
      return;
    }
    final screenSize = (appSize.width + appSize.height) / 2;
    if (screenSize > 1600) {
      scale = 1.25;
    } else if (screenSize > 1400) {
      scale = 1.15;
    } else if (screenSize > 1000) {
      scale = 1.1;
    } else if (screenSize > 800) {
      scale = 1;
    } else {
      scale = .9;
    }
    debugPrint('screenSize=$screenSize, scale=$scale');
  }

  late final double scale;

  /// The current theme colors for the app
  final AppColors colors = AppColors();

  /// Rounded edge corner radii
  late final _Corners corners = _Corners();

  late final _Shadows shadows = _Shadows();

  /// Padding and margin values
  late final _Insets insets = _Insets(scale);

  /// Text styles
  late final _Text text = _Text(scale);

  /// Animation Durations
  final _Times times = _Times();

  /// Shared sizes
  late final _Sizes sizes = _Sizes();
}

@immutable
class _Text {
  _Text(this._scale);
  final double _scale;

  final Map<String, TextStyle> _wonderTitleFonts = {
    'en': const TextStyle(fontFamily: 'Yeseva'),
  };

  TextStyle _getFontForLocale(Map<String, TextStyle> fonts) {
    return fonts.entries.first.value;
  }

  TextStyle get wonderTitleFont => _getFontForLocale(_wonderTitleFonts);

  late final TextStyle wonderTitle =
      _createFont(wonderTitleFont, sizePx: 64, heightPx: 56);

  TextStyle _createFont(TextStyle style,
      {required double sizePx,
      double? heightPx,
      double? spacingPc,
      FontWeight? weight}) {
    sizePx *= _scale;
    if (heightPx != null) {
      heightPx *= _scale;
    }
    return style.copyWith(
        fontSize: sizePx,
        height: heightPx != null ? (heightPx / sizePx) : style.height,
        letterSpacing:
            spacingPc != null ? sizePx * spacingPc * 0.01 : style.letterSpacing,
        fontWeight: weight);
  }
}

@immutable
class _Times {
  final Duration fast = const Duration(milliseconds: 300);
  final Duration med = const Duration(milliseconds: 600);
  final Duration slow = const Duration(milliseconds: 900);
  final Duration pageTransition = const Duration(milliseconds: 200);
}

@immutable
class _Corners {
  late final double sm = 4;
  late final double md = 8;
  late final double lg = 32;
}

class _Sizes {
  double get maxContentWidth1 => 800;
  double get maxContentWidth2 => 600;
  double get maxContentWidth3 => 500;
  final Size minAppSize = const Size(380, 675);
}

@immutable
class _Insets {
  _Insets(this._scale);
  final double _scale;

  late final double xxs = 4 * _scale;
  late final double xs = 8 * _scale;
  late final double sm = 16 * _scale;
  late final double md = 24 * _scale;
  late final double lg = 32 * _scale;
  late final double xl = 48 * _scale;
  late final double xxl = 56 * _scale;
  late final double offset = 80 * _scale;
}

@immutable
class _Shadows {
  final textSoft = [
    Shadow(
        color: Colors.black.withOpacity(.25),
        offset: const Offset(0, 2),
        blurRadius: 4),
  ];
  final text = [
    Shadow(
        color: Colors.black.withOpacity(.6),
        offset: const Offset(0, 2),
        blurRadius: 2),
  ];
  final textStrong = [
    Shadow(
        color: Colors.black.withOpacity(.6),
        offset: const Offset(0, 4),
        blurRadius: 6),
  ];
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sized_context/sized_context.dart';
import 'package:wonderous_clone/screens/wonder_illustration/widgets/wonders_color_extensions.dart';
import 'package:wonderous_clone/utils/asset_path.dart';

import '../../utils/enums.dart';
import 'config/wonder_illustration_config.dart';
import 'widgets/fade_color_transitions.dart';
import 'widgets/illustration_piece.dart';
import 'widgets/illustration_texture.dart';
import 'widgets/wonder_illustration_builder.dart';

class TajMahalIllustration extends StatelessWidget {
  TajMahalIllustration({Key? key, required this.config}) : super(key: key);
  final WonderIllustrationConfig config;

  final fgColor = WonderType.tajMahal.fgColor;
  final bgColor = WonderType.tajMahal.bgColor;
  final assetPath = WonderType.tajMahal.assetPath;

  @override
  Widget build(BuildContext context) {
    return WonderIllustrationBuilder(
      config: config,
      bgBuilder: _buildBg,
      mgBuilder: _buildMg,
      fgBuilder: _buildFg,
      wonderType: WonderType.tajMahal,
    );
  }

  List<Widget> _buildBg(BuildContext context, Animation<double> anim) {
    return [
      // Bg color
      FadeColorTransition(color: fgColor, animation: anim),
      // Noise texture
      Positioned.fill(
        child: IllustrationTexture(
          ImagePaths.roller2,
          flipY: true,
          opacity: anim.drive(Tween(begin: 0, end: .7)),
          color: bgColor,
          scale: config.shortMode ? 3 : 1.15,
        ),
      ),
      // Sun
      IllustrationPiece(
        fileName: 'sun.png',
        initialOffset: const Offset(0, 50),
        enableHero: true,
        heightFactor: .3,
        minHeight: 140,
        offset: config.shortMode
            ? Offset(-100, context.heightPx * -.02)
            : Offset(-150, context.heightPx * -.34),
      ),
    ];
  }

  List<Widget> _buildMg(BuildContext context, Animation<double> anim) {
    return [
      LayoutBuilder(builder: (_, constraints) {
        const double minHeight = 230, heightFactor = .6, poolScale = 1;
        return Stack(
          children: [
            IllustrationPiece(
              fileName: 'taj-mahal.png',
              heightFactor: heightFactor,
              minHeight: minHeight,
              enableHero: true,
              zoomAmt: .05,
              fractionalOffset: Offset(0, config.shortMode ? .12 : -.15),
              top: config.shortMode
                  ? null
                  : (_) => const FractionalTranslation(
                        translation: Offset(0, heightFactor),
                        child: IllustrationPiece(
                          fileName: 'pool.png',
                          heightFactor: heightFactor * poolScale,
                          minHeight: minHeight * poolScale,
                          zoomAmt: .05,
                        ),
                      ),
            ),
          ],
        );
      }),
    ];
  }

  List<Widget> _buildFg(BuildContext context, Animation<double> anim) {
    /// Let the mangos scale up as the width of the screen grows
    final mangoScale = max(context.widthPx - 400, 0) / 1000;
    return [
      IllustrationPiece(
        fileName: 'foreground-right.png',
        alignment: Alignment.bottomRight,
        initialOffset: const Offset(20, 40),
        initialScale: .85,
        heightFactor: .5 + .4 * mangoScale,
        fractionalOffset: const Offset(.3, 0),
        zoomAmt: .25,
      ),
      IllustrationPiece(
        fileName: 'foreground-left.png',
        alignment: Alignment.bottomLeft,
        initialScale: .9,
        initialOffset: const Offset(-40, 60),
        heightFactor: .6 + .3 * mangoScale,
        fractionalOffset: const Offset(-.3, 0),
        zoomAmt: .25,
        dynamicHzOffset: 0,
      ),
    ];
  }
}

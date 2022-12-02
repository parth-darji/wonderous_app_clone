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

class PyramidsGizaIllustration extends StatelessWidget {
  PyramidsGizaIllustration({Key? key, required this.config}) : super(key: key);
  final WonderIllustrationConfig config;
  final String assetPath = WonderType.pyramidsGiza.assetPath;
  final fgColor = WonderType.pyramidsGiza.fgColor;
  final bgColor = WonderType.pyramidsGiza.bgColor;

  @override
  Widget build(BuildContext context) {
    return WonderIllustrationBuilder(
      wonderType: WonderType.pyramidsGiza,
      config: config,
      bgBuilder: _buildBg,
      mgBuilder: _buildMg,
      fgBuilder: _buildFg,
    );
  }

  List<Widget> _buildBg(BuildContext context, Animation<double> anim) {
    return [
      FadeColorTransition(animation: anim, color: fgColor),
      Positioned.fill(
        child: IllustrationTexture(
          ImagePaths.roller2,
          color: const Color(0xff797FD8),
          opacity: anim.drive(Tween(begin: 0, end: .75)),
          flipY: true,
          scale: config.shortMode ? 4 : 1.15,
        ),
      ),
      IllustrationPiece(
        fileName: 'moon.png',
        initialOffset: const Offset(0, 50),
        enableHero: true,
        heightFactor: .15,
        minHeight: 100,
        offset: config.shortMode
            ? Offset(120, context.heightPx * -.05)
            : Offset(120, context.heightPx * -.35),
        zoomAmt: .05,
      ),
    ];
  }

  List<Widget> _buildMg(BuildContext context, Animation<double> anim) {
    return [
      IllustrationPiece(
        fileName: 'pyramids.png',
        enableHero: true,
        heightFactor: .5,
        minHeight: 300,
        zoomAmt: config.shortMode ? -.2 : -2,
        fractionalOffset:
            Offset(config.shortMode ? .015 : 0, config.shortMode ? .17 : -.15),
      )
    ];
  }

  List<Widget> _buildFg(BuildContext context, Animation<double> anim) {
    return [
      const IllustrationPiece(
        fileName: 'foreground-back.png',
        alignment: Alignment.bottomCenter,
        initialOffset: Offset(20, 40),
        initialScale: .95,
        heightFactor: .55,
        fractionalOffset: Offset(.2, -.01),
        zoomAmt: .1,
        dynamicHzOffset: 150,
      ),
      const IllustrationPiece(
        fileName: 'foreground-front.png',
        alignment: Alignment.bottomCenter,
        initialScale: .9,
        initialOffset: Offset(-40, 60),
        heightFactor: .55,
        fractionalOffset: Offset(-.09, 0.02),
        zoomAmt: .25,
        dynamicHzOffset: -150,
      ),
    ];
  }
}
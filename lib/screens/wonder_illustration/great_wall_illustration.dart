import 'package:flutter/material.dart';
import 'package:sized_context/sized_context.dart';
import 'package:wonderous_clone/screens/wonder_illustration/widgets/wonders_color_extensions.dart';
import 'package:wonderous_clone/utils/asset_path.dart';

import '../../utils/colors.dart';
import '../../utils/enums.dart';
import 'config/wonder_illustration_config.dart';
import 'widgets/fade_color_transitions.dart';
import 'widgets/illustration_piece.dart';
import 'widgets/illustration_texture.dart';
import 'widgets/wonder_illustration_builder.dart';

class GreatWallIllustration extends StatelessWidget {
  GreatWallIllustration({Key? key, required this.config}) : super(key: key);
  final WonderIllustrationConfig config;
  final String assetPath = WonderType.greatWall.assetPath;
  final fgColor = WonderType.greatWall.fgColor;
  final bgColor = WonderType.greatWall.bgColor;

  @override
  Widget build(BuildContext context) {
    return WonderIllustrationBuilder(
      config: config,
      bgBuilder: _buildBg,
      mgBuilder: _buildMg,
      fgBuilder: _buildFg,
      wonderType: WonderType.greatWall,
    );
  }

  List<Widget> _buildBg(BuildContext context, Animation<double> anim) {
    return [
      FadeColorTransition(
          animation: anim, color: AppColors.shift(fgColor, .15)),
      Positioned.fill(
        child: IllustrationTexture(
          ImagePaths.roller2,
          flipX: true,
          color: const Color(0xff688750),
          opacity: anim.drive(Tween(begin: 0, end: 1)),
          scale: config.shortMode ? 4 : 1.15,
        ),
      ),
      IllustrationPiece(
        fileName: 'sun.png',
        initialOffset: const Offset(0, 50),
        enableHero: true,
        heightFactor: config.shortMode ? .07 : .25,
        minHeight: 120,
        offset: config.shortMode
            ? Offset(-40, context.heightPx * -.06)
            : Offset(-65, context.heightPx * -.3),
      ),
    ];
  }

  List<Widget> _buildMg(BuildContext context, Animation<double> anim) {
    return [
      IllustrationPiece(
        fileName: 'great-wall.png',
        heightFactor: config.shortMode ? .45 : .65,
        minHeight: 250,
        zoomAmt: .05,
        enableHero: true,
        fractionalOffset: Offset(0, config.shortMode ? .15 : -.15),
      ),
    ];
  }

  List<Widget> _buildFg(BuildContext context, Animation<double> anim) {
    return [
      const IllustrationPiece(
        fileName: 'foreground-left.png',
        alignment: Alignment.bottomCenter,
        initialScale: .9,
        initialOffset: Offset(-40, 60),
        heightFactor: .85,
        fractionalOffset: Offset(-.4, .45),
        zoomAmt: .25,
        dynamicHzOffset: -150,
      ),
      const IllustrationPiece(
        fileName: 'foreground-right.png',
        alignment: Alignment.bottomCenter,
        initialOffset: Offset(20, 40),
        initialScale: .95,
        heightFactor: 1,
        fractionalOffset: Offset(.4, .3),
        zoomAmt: .1,
        dynamicHzOffset: 150,
      ),
    ];
  }
}

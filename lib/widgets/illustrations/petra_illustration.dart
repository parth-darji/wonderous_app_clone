import 'package:extra_alignments/extra_alignments.dart';
import 'package:flutter/material.dart';
import 'package:page_view_animation_demo/assets.dart';
import 'package:page_view_animation_demo/utils/wonder_extensions.dart';

import '../../enum/wonder_types.dart';
import '../../logic/config/wonder_illustration_config.dart';
import '../../screens/wonder_illustration/wonder_illustration_builder.dart';
import '../../utils/common_lib/illustration_texture.dart';
import '../../utils/wonder_hero.dart';
import '../face_color_transition.dart';

class PetraIllustration extends StatelessWidget {
  PetraIllustration({Key? key, required this.config}) : super(key: key);
  final WonderIllustrationConfig config;
  final String assetPath = WonderType.petra.assetPath;
  final fgColor = WonderType.petra.fgColor;
  final bgColor = WonderType.petra.bgColor;

  @override
  Widget build(BuildContext context) {
    return WonderIllustrationBuilder(
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
          ImagePaths.roller1,
          color: Colors.white,
          flipX: true,
          opacity: anim.drive(Tween(begin: 0, end: .25)),
        ),
      ),
      Align(
        alignment: Alignment(-.3, config.shortMode ? -1.5 : -1.23),
        child: FractionalTranslation(
          translation: Offset(0, .5 * anim.value),
          child: WonderHero(
            config,
            'petra-moon',
            child: Image.asset(
              '$assetPath/moon.png',
              opacity: anim,
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildMg(BuildContext context, Animation<double> anim) => [
        Center(
          child: FractionalTranslation(
            translation: Offset(0, config.shortMode ? 0.05 : -.1),
            child: FractionallySizedBox(
              widthFactor: config.shortMode ? 1 : 2,
              child: WonderHero(
                config,
                'petra-mg',
                child: Image.asset('$assetPath/petra.png',
                    fit: BoxFit.contain, opacity: anim),
              ),
            ),
          ),
        ),
      ];

  List<Widget> _buildFg(BuildContext context, Animation<double> anim) {
    final curvedAnim = Curves.easeOut.transform(anim.value);
    return [
      Stack(children: [
        CenterLeft(
          child: FractionallySizedBox(
            widthFactor: .63,
            child: FractionalTranslation(
              translation: Offset(-.3 * (1 - curvedAnim), 0),
              child: Transform.scale(
                scale: 1.1 + config.zoom * .2,
                child: FractionalTranslation(
                  translation: const Offset(-.35, -.07),
                  child: Image.asset('$assetPath/foreground-left.png',
                      opacity: anim, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
        ),
        CenterRight(
          child: FractionallySizedBox(
            widthFactor: .72,
            child: FractionalTranslation(
              translation: Offset(.3 * (1 - curvedAnim), 0),
              child: Transform.scale(
                scale: 1 + config.zoom * .4,
                child: FractionalTranslation(
                  translation: const Offset(.4, -.03),
                  child: Image.asset('$assetPath/foreground-right.png',
                      opacity: anim, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
        ),
      ])
    ];
  }
}

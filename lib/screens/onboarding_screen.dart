import 'package:extra_alignments/extra_alignments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:wonderous_clone/logic/wonders_logic.dart';
import 'package:wonderous_clone/screens/wonder_illustration/widgets/wonders_color_extensions.dart';

import '../models/wonder_data.dart';
import '../utils/colors.dart';
import '../utils/enums.dart';
import '../utils/haptics.dart';
import 'wonder_illustration/animated_clouds.dart';
import 'wonder_illustration/config/wonder_illustration_config.dart';
import 'wonder_illustration/controls/app_page_indicator.dart';
import 'wonder_illustration/widgets/themed_text.dart';
import 'wonder_illustration/widgets/wonders_title_text.dart';
import 'wonder_illustration/wonder_illustration.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late final _pageController = PageController(
    viewportFraction: 1,
    initialPage: _numWonders *
        9999, // allow 'infinite' scrolling by starting at a very high page
  );

  List<WonderData> get _wonders => WondersLogic.all;

  /// Set initial wonderIndex
  late int _wonderIndex = 0;
  int get _numWonders => _wonders.length;

  /// Used to let the foreground fade in when this view is returned to (from details)
  bool _fadeInOnNextBuild = false;

  /// All of the items that should fade in when returning from details view.
  /// Using individual tweens is more efficient than tween the entire parent
  final _fadeAnims = <AnimationController>[];

  WonderData get currentWonder => _wonders[_wonderIndex];

  bool _isSelected(WonderType t) => t == currentWonder.type;

  void _handlePageViewChanged(v) {
    setState(() => _wonderIndex = v % _numWonders);
    AppHaptics.lightImpact();
  }

  void _handleFadeAnimInit(AnimationController controller) {
    _fadeAnims.add(controller);
    controller.value = 1;
  }

  void _handlePageIndicatorDotPressed(int index) => _setPageIndex(index);

  void _setPageIndex(int index) {
    if (index == _wonderIndex) return;
    // To support infinite scrolling, we can't jump directly to the pressed index. Instead, make it relative to our current position.
    final pos =
        ((_pageController.page ?? 0) / _numWonders).floor() * _numWonders;
    _pageController.jumpToPage(pos + index);
  }

  void _startDelayedFgFade() async {
    try {
      for (var a in _fadeAnims) {
        a.value = 0;
      }
      await Future.delayed(300.ms);
      for (var a in _fadeAnims) {
        a.forward();
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_fadeInOnNextBuild == true) {
      _startDelayedFgFade();
      _fadeInOnNextBuild = false;
    }

    return Stack(
      children: [
        /// Background
        ..._buildBgAndClouds(),

        /// Wonders Illustrations (main content)
        _buildMgPageView(),

        /// Foreground illustrations and gradients
        _buildFgAndGradients(),

        /// Controls that float on top of the various illustrations
        _buildFloatingUi(),
      ],
    ).animate().fadeIn();
  }

  Widget _buildMgPageView() {
    return ExcludeSemantics(
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: _handlePageViewChanged,
        itemBuilder: (_, index) {
          final wonder = _wonders[index % _wonders.length];
          final wonderType = wonder.type;
          bool isShowing = _isSelected(wonderType);
          final config = WonderIllustrationConfig.mg(
            isShowing: isShowing,
          );
          return WonderIllustration(wonderType, config: config);
        },
      ),
    );
  }

  List<Widget> _buildBgAndClouds() {
    return [
      // Background
      ..._wonders.map((e) {
        final config =
            WonderIllustrationConfig.bg(isShowing: _isSelected(e.type));
        return WonderIllustration(e.type, config: config);
      }).toList(),
      // Clouds
      FractionallySizedBox(
        widthFactor: 1,
        heightFactor: .5,
        child: AnimatedClouds(wonderType: currentWonder.type, opacity: 1),
      )
    ];
  }

  Widget _buildFgAndGradients() {
    Widget buildSwipeableBgGradient(Color fgColor) {
      return IgnorePointer(
        child: FractionallySizedBox(
          heightFactor: .6,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  fgColor.withOpacity(0),
                ],
                stops: const [0, 1],
              ),
            ),
          ),
        ),
      );
    }

    final gradientColor = currentWonder.type.bgColor;
    return Stack(children: [
      /// Foreground gradient-1, gets darker when swiping up
      BottomCenter(
        child: buildSwipeableBgGradient(gradientColor.withOpacity(.65)),
      ),

      /// Foreground decorators
      ..._wonders.map((e) {
        final config = WonderIllustrationConfig.fg(
          isShowing: _isSelected(e.type),
        );
        return Animate(
            effects: const [FadeEffect()],
            onPlay: _handleFadeAnimInit,
            child: IgnorePointer(
                child: WonderIllustration(e.type, config: config)));
      }).toList(),

      /// Foreground gradient-2, gets darker when swiping up
      BottomCenter(
        child: buildSwipeableBgGradient(gradientColor),
      ),
    ]);
  }

  Widget _buildFloatingUi() {
    return Stack(children: [
      /// Floating controls / UI
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: RepaintBoundary(
          child: OverflowBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: double.infinity),
                const Spacer(),

                /// Title Content
                LightText(
                  child: IgnorePointer(
                    ignoringSemantics: false,
                    child: Transform.translate(
                      offset: const Offset(0, 30),
                      child: Column(
                        children: [
                          Semantics(
                            liveRegion: true,
                            button: true,
                            header: true,
                            onIncrease: () => _setPageIndex(_wonderIndex + 1),
                            onDecrease: () => _setPageIndex(_wonderIndex - 1),
                            onTap: () {},
                            // Hide the title when the menu is open for visual polish
                            child: WonderTitleText(currentWonder,
                                enableShadows: true),
                          ),
                          const Gap(24),
                          AppPageIndicator(
                            count: _numWonders,
                            controller: _pageController,
                            color: AppColors.white,
                            dotSize: 8,
                            onDotPressed: _handlePageIndicatorDotPressed,
                          ),
                          const Gap(24),
                        ],
                      ),
                    ),
                  ),
                ),
                const Gap(24),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}

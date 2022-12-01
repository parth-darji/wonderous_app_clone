import 'package:extra_alignments/extra_alignments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:page_view_animation_demo/logic/wonders_logic.dart';
import 'package:page_view_animation_demo/utils/colors.dart';
import 'package:page_view_animation_demo/utils/wonder_extensions.dart';

import '../controllers/verticle_swipe_controller.dart';
import '../enum/wonder_types.dart';
import '../logic/config/wonder_illustration_config.dart';
import '../models/wonders_data.dart';
import '../utils/haptics.dart';
import '../utils/router.dart';
import '../widgets/app_page_indicator.dart';
import '../widgets/gradient_container.dart';
import '../widgets/illustrations/animated_clouds.dart';
import '../widgets/light_text.dart';
import '../widgets/wonder_illustration.dart';
import '../widgets/wonders_title_text_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// Shows a horizontally scrollable list PageView sandwiched between Foreground and Background layers
/// arranged in a parallax style.
class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final _pageController = PageController(
    viewportFraction: 1,
    initialPage: _numWonders *
        9999, // allow 'infinite' scrolling by starting at a very high page
  );
  List<WonderData> get _wonders => WondersLogic().all;

  /// Set initial wonderIndex
  late int _wonderIndex = 0;
  int get _numWonders => _wonders.length;

  /// Used to polish the transition when leaving this page for the details view.
  /// Used to capture the _swipeAmt at the time of transition, and freeze the wonder foreground in place as we transition away.
  double? _swipeOverride;

  /// Used to let the foreground fade in when this view is returned to (from details)
  bool _fadeInOnNextBuild = false;

  /// All of the items that should fade in when returning from details view.
  /// Using individual tweens is more efficient than tween the entire parent
  final _fadeAnims = <AnimationController>[];

  WonderData get currentWonder => _wonders[_wonderIndex];

  late final VerticalSwipeController _swipeController =
      VerticalSwipeController(this, _showDetailsPage);

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

  void _showDetailsPage() async {
    _swipeOverride = _swipeController.swipeAmt.value;
    context.push(ScreenPaths.wonderDetails(currentWonder.type));
    await Future.delayed(const Duration(milliseconds: 100));
    _swipeOverride = null;
    _fadeInOnNextBuild = true;
  }

  void _startDelayedFgFade() async {
    try {
      for (var a in _fadeAnims) {
        a.value = 0;
      }
      await Future.delayed(const Duration(milliseconds: 300));
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

    return _swipeController.wrapGestureDetector(Container(
      color: AppColors.black,
      child: Stack(
        children: [
          Stack(
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
          ).animate().fadeIn(),
        ],
      ),
    ));
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
          return _swipeController.buildListener(
            builder: (swipeAmt, _, child) {
              final config = WonderIllustrationConfig.mg(
                isShowing: isShowing,
                zoom: .05 * swipeAmt,
              );
              return WonderIllustration(wonderType, config: config);
            },
          );
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
      return _swipeController.buildListener(
          builder: (swipeAmt, isPointerDown, _) {
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
                    fgColor.withOpacity(.5 +
                        fgColor.opacity * .25 +
                        (isPointerDown ? .05 : 0) +
                        swipeAmt * .20),
                  ],
                  stops: const [0, 1],
                ),
              ),
            ),
          ),
        );
      });
    }

    final gradientColor = currentWonder.type.bgColor;
    return Stack(children: [
      /// Foreground gradient-1, gets darker when swiping up
      BottomCenter(
        child: buildSwipeableBgGradient(gradientColor.withOpacity(.65)),
      ),

      /// Foreground decorators
      ..._wonders.map((e) {
        return _swipeController.buildListener(builder: (swipeAmt, _, child) {
          final config = WonderIllustrationConfig.fg(
            isShowing: _isSelected(e.type),
            zoom: .4 * (_swipeOverride ?? swipeAmt),
          );
          return Animate(
              effects: const [FadeEffect()],
              onPlay: _handleFadeAnimInit,
              child: IgnorePointer(
                  child: WonderIllustration(e.type, config: config)));
        });
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
                            onTap: () => _showDetailsPage(),
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
                            semanticPageTitle: 'homeSemanticWonder',
                          ),
                          const Gap(24),
                        ],
                      ),
                    ),
                  ),
                ),

                /// Animated arrow and background
                /// Wrap in a container that is full-width to make it easier to find for screen readers
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,

                  /// Lose state of child objects when index changes, this will re-run all the animated switcher and the arrow anim
                  key: ValueKey(_wonderIndex),
                  child: Stack(
                    children: [
                      /// Expanding rounded rect that grows in height as user swipes up
                      Positioned.fill(
                          child: _swipeController.buildListener(
                        builder: (swipeAmt, _, child) {
                          double heightFactor = .5 + .5 * (1 + swipeAmt * 4);
                          return FractionallySizedBox(
                            alignment: Alignment.bottomCenter,
                            heightFactor: heightFactor,
                            child:
                                Opacity(opacity: swipeAmt * .5, child: child),
                          );
                        },
                        child: VtGradient(
                          [
                            AppColors.white.withOpacity(0),
                            AppColors.white.withOpacity(1)
                          ],
                          const [.3, 1],
                          borderRadius: BorderRadius.circular(99),
                        ),
                      )),
                    ],
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

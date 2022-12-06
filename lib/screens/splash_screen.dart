import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonderous_clone/screens/onboarding_screen.dart';

import '../utils/asset_path.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  /// used to animate the image
  bool isVisible = false;

  @override
  void initState() {
    navigateToOnboardingScreen();
    super.initState();
  }

  /// used to navigate to onboarding screen after some times
  Future<void> navigateToOnboardingScreen() async {
    await Future.delayed(const Duration(seconds: 1), () async {
      setState(() {
        isVisible = true;
      });
      await Future.delayed(
        const Duration(seconds: 3),
        () {
          Get.off(
            () => const OnboardingScreen(),
            duration: const Duration(milliseconds: 1000),
            transition: Transition.fade,
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 200,
          width: 200,
          child: AnimatedOpacity(
            duration: const Duration(seconds: 1),
            opacity: isVisible ? 1 : 0,
            child: Image.asset(Asset.appLogo),
          ),
        ),
      ),
    );
  }
}

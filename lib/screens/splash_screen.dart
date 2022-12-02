import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonderous_page_view_animation_demo/utils/asset_path.dart';
import 'package:wonderous_page_view_animation_demo/utils/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    navigateToOnboardingScreen();
    super.initState();
  }

  /// used to navigate to onboarding screen after some times
  Future<void> navigateToOnboardingScreen() async {
    await Future.delayed(const Duration(seconds: 3), () {
      Get.toNamed(Routes.onboardingScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 200,
          width: 200,
          child: Image.asset(Asset.appLogo),
        ),
      ),
    );
  }
}

import 'package:get/get.dart';
import 'package:wonderous_page_view_animation_demo/screens/onboarding_screen.dart';
import 'package:wonderous_page_view_animation_demo/screens/splash_screen.dart';

import '../screens/home_screen.dart';

class Routes {
  static String splashScreen = '/splashScreen';
  static String onboardingScreen = '/onboardingScreen';
  static String homeScreen = '/homeScreen';
}

final pages = [
  GetPage(
    name: Routes.splashScreen,
    page: () => const SplashScreen(),
  ),
  GetPage(
    name: Routes.onboardingScreen,
    page: () => const OnboardingScreen(),
  ),
  GetPage(
    name: Routes.homeScreen,
    page: () => const HomeScreen(),
  ),
];

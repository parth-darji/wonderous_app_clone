import 'package:get/get.dart';

import '../screens/home_screen.dart';

class Routes {
  static String splashScreen = '/splashScreen';
  static String onboardingScreen = '/onboardingScreen';
  static String homeScreen = '/homeScreen';
}

final getPages = [
  GetPage(
    name: Routes.splashScreen,
    page: () => const HomeScreen(),
  ),
  GetPage(
    name: Routes.onboardingScreen,
    page: () => const HomeScreen(),
  ),
  GetPage(
    name: Routes.homeScreen,
    page: () => const HomeScreen(),
  ),
];

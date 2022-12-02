import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonderous_page_view_animation_demo/utils/routes.dart';
import 'package:wonderous_page_view_animation_demo/utils/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: pages,
      initialRoute: Routes.splashScreen,
      theme: light(),
      darkTheme: dark(),
      themeMode: ThemeMode.system,
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../enum/wonder_types.dart';
import '../screens/home_screen.dart';

/// Shared paths / urls used across the app
class ScreenPaths {
  static String home = '/home';
  static String wonderDetails(WonderType type, {int tabIndex = 0}) =>
      '/wonder/${type.name}?t=$tabIndex';
}

/// Routing table, matches string paths to UI Screens
final appRouter = GoRouter(
  routes: [
    AppRoute(ScreenPaths.home, (_) => const HomeScreen()),
    // AppRoute('/wonder/:type', (s) {
    //   int tab = int.tryParse(s.queryParams['t'] ?? '') ?? 0;
    //   return WonderDetailsScreen(
    //     type: _parseWonderType(s.params['type']!),
    //     initialTabIndex: tab,
    //   );
    // }, useFade: true),
  ],
);

/// Custom GoRoute sub-class to make the router declaration easier to read
class AppRoute extends GoRoute {
  AppRoute(String path, Widget Function(GoRouterState s) builder,
      {List<GoRoute> routes = const [], this.useFade = false})
      : super(
          path: path,
          routes: routes,
          pageBuilder: (context, state) {
            final pageContent = Scaffold(
              body: builder(state),
              resizeToAvoidBottomInset: false,
            );
            if (useFade) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: pageContent,
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              );
            }
            return CupertinoPage(child: pageContent);
          },
        );
  final bool useFade;
}

// _handleRedirect(GoRouterState state) {
//   // Prevent anyone from navigating away from `/` if app is starting up.
//   debugPrint('Navigate to: ${state.location}');
//   return null; // do nothing
// }

// WonderType _parseWonderType(String value) =>
//     _tryParseWonderType(value) ?? WonderType.chichenItza;

// WonderType? _tryParseWonderType(String value) =>
//     WonderType.values.asNameMap()[value];

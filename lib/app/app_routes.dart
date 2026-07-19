import 'package:clean_starter/core/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String onboarding = "onboarding";
  static const String login = "login";
  static const String splash = "/";

  static Route<dynamic> onGenerateRoutes(RouteSettings routeSettings) {
    debugPrint('Generating route for: ${routeSettings.name}');
    late Route<dynamic> pageRoute;

    switch (routeSettings.name) {
      case onboarding:
        pageRoute = MaterialPageRoute(
          builder: (context) {
            return const SplashScreen();
          },
        );
        break;
      case splash:
        pageRoute = MaterialPageRoute(
          builder: (context) {
            return const SplashScreen();
          },
        );
        break;
    }
    return pageRoute;
  }

  static Route<dynamic> onUnknownRoute(RouteSettings routeSettings) {
    return MaterialPageRoute(builder: (_) => const SizedBox());
  }
}

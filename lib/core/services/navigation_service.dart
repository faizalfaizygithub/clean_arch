import 'package:flutter/material.dart';

class NavigationService {
  final navigationKey = GlobalKey<NavigatorState>();

  Future<T?>? pushNamed<T extends Object?>(
    String routeName, {
    Object? args,
  }) =>
      navigationKey.currentState?.pushNamed(routeName, arguments: args);

  Future<T?>? pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? args,
  }) =>
      navigationKey.currentState?.pushReplacementNamed(
        routeName,
        arguments: args,
        result: result,
      );

  Future<T?>? pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName, {
    bool removeAll = true,
    String? untilRoute,
    Object? arguments,
  }) {
    bool predicate(Route<dynamic> route) {
      if (removeAll) return false;
      if (untilRoute != null) {
        // Keep the route if it matches untilRoute
        return route.settings.name == untilRoute;
      }
      // Keep only the first route by default if not removing all
      return route.isFirst;
    }

    return navigationKey.currentState?.pushNamedAndRemoveUntil(
      newRouteName,
      predicate,
      arguments: arguments,
    );
  }

  void pop<T extends Object?>([T? result]) =>
      navigationKey.currentState?.pop(result);

  void popUntil(String routeName) {
    bool predicate(Route<dynamic> route) {
      // Keep the route if it matches untilRoute
      return route.settings.name == routeName;
    }

    return navigationKey.currentState?.popUntil(
      predicate,
    );
  }
}

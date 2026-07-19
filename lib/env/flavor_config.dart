import 'package:flutter/material.dart';

enum Flavor {
  qa,
  dev,
  uat,
  production,
}

class FlavorValues {
  const FlavorValues({
    required this.baseUrl,
    required this.webSocketUrl,
  });

  final String baseUrl;
  final String webSocketUrl;
}

class FlavorConfig {
  FlavorConfig._internal(
    this.flavor,
    this.name,
    this.color,
    this.values,
  );

  factory FlavorConfig({
    required Flavor flavor,
    required String name,
    required Color color,
    required FlavorValues values,
  }) =>
      _instance ??= FlavorConfig._internal(flavor, name, color, values);

  final Flavor flavor;
  final String name;
  final Color color;
  final FlavorValues values;

  static FlavorConfig? _instance;

  static FlavorConfig get instance => _instance!;

  static bool isProduction() => _instance!.flavor == Flavor.production;

  static bool isDev() => _instance!.flavor == Flavor.dev;

  static bool isUat() => _instance!.flavor == Flavor.uat;

  static bool isInTest() => _instance!.flavor == Flavor.qa;
}

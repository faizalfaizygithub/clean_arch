import 'package:flutter/material.dart';

import '../app/app.dart';
import '../common/common_setup.dart';
import 'flavor_config.dart';

Future<void> main() async {
  await commonSetup();
  const values = FlavorValues(
    baseUrl: 'https://furnyshop.noviindusdemosites.in/api/v1',
    webSocketUrl: 'wss://furnyshop.noviindusdemosites.in/',
  );

  FlavorConfig(
    flavor: Flavor.dev,
    name: 'PROD',
    color: Colors.black,
    values: values,
  );

  runApp(const MyApp());
}

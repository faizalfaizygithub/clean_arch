import 'package:flutter/material.dart';

import '../app/app.dart';
import '../common/common_setup.dart';
import 'flavor_config.dart';

Future<void> main() async {
  await commonSetup();
  const values = FlavorValues(
    baseUrl: 'https://furnyshop.noviindusdemosites.in/api/v1',
    webSocketUrl: '',
  );

  FlavorConfig(
    flavor: Flavor.dev,
    name: 'QA',
    color: Colors.black,
    values: values,
  );

  runApp(
    const MyApp(),
  );
}

import 'package:flutter/material.dart';

import '../app/app.dart';
import '../common/common_setup.dart';
import 'flavor_config.dart';

Future<void> main() async {
  await commonSetup();
  const values = FlavorValues(
    baseUrl: 'http://192.168.29.204:8001/api/',
    webSocketUrl: 'ws://192.168.29.204:8001',
  );

  FlavorConfig(
    flavor: Flavor.dev,
    name: 'DEV',
    color: Colors.black,
    values: values,
  );

  runApp(const MyApp());
}

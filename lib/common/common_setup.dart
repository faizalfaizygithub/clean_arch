import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../di/locator.dart' as locator;

Future<void> commonSetup() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await locator.setupLocator();
}

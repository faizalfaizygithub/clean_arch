import 'package:clean_starter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:clean_starter/core/services/navigation_service.dart';
import 'package:clean_starter/di/locator.dart';
import '../core/theme/app_theme.dart';
import 'app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App by Noviindus',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      navigatorKey: getIt<NavigationService>().navigationKey,
      onGenerateRoute: AppRoutes.onGenerateRoutes,
      onUnknownRoute: AppRoutes.onUnknownRoute,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

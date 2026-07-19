import 'package:clean_starter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  AppLocalizations get locale => AppLocalizations.of(this)!;
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get primaryTextTheme => Theme.of(this).primaryTextTheme;
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  bool get isDarkMode {
    return Theme.of(this).brightness == Brightness.dark;
  }

  bool get isTablet {
    return width >= 600;
  }
}

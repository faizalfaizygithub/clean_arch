import 'package:flutter/material.dart';

extension StringExtensions on String {
  /// Returns true if [this] only contains white-spaces.
  bool get isBlank => trim().isEmpty;

  /// Returns true if [this] contains characters other than white-spaces.
  bool get isNotBlank => trim().isNotEmpty;

  String get capitalized {
    if (isBlank) return this;
    if (characters.length == 1) return toUpperCase();
    return characters.first.toUpperCase() + characters.skip(1).toString();
  }

  String title() => split(' ').map((e) => e.capitalized).join(' ');

  /// allows to convert a hex string to [Color]. Returns null if unable
  /// to convert.
  /// 3 digit hex codes are also supported.
  Color? toColor() {
    try {
      var colorString = startsWith('#') ? substring(1) : this;
      if (colorString.length == 3) {
        colorString = (colorString.substring(0, 1) * 2) +
            (colorString.substring(1, 2) * 2) +
            colorString.substring(2) * 2;
      }
      final hexNumber = int.parse(colorString, radix: 16);
      return Color.fromARGB(
        255,
        (hexNumber >> 16) & 0xFF,
        ((hexNumber >> 8) & 0xFF),
        (hexNumber >> 0) & 0xFF,
      );
    } catch (_) {
      return null;
    }
  }
}

extension StringExtensionsNullable on String? {
  bool get isNullOrEmpty {
    if (this == null) {
      return true;
    } else {
      final newValue = this?.trim();
      return newValue?.isEmpty ?? true;
    }
  }

  bool get isNotNullOrEmpty => !isNullOrEmpty;
}

extension DateTiimeExtensions on DateTime {
  /// This is helpful in cases where comparison of only dates is required.
  DateTime get dateOnly => DateTime(year, month, day);

  /// Returns true if [this] is same as the date of today.
  /// This doesn't account for time.
  bool get isToday {
    final now = DateTime.now();
    return day == now.day && month == now.month && year == now.year;
  }

  /// Return the whether [this] this same as [other]
  bool isSameDay(DateTime other) {
    return day == other.day && month == other.month && year == other.year;
  }

  /// Returns current date without time information.
  DateTime get today => DateTime.now().dateOnly;

  /// Returns [DateTime] with previous day
  DateTime get previousDay => subtract(const Duration(days: 1));

  /// Returns [DateTime] with next day
  DateTime get nextDay => add(const Duration(days: 1));

  /// Returns tomorrow's date without time information.
  DateTime get tomorrow => DateTime.now().nextDay.dateOnly;

  /// Returns yesterday's date without time information.
  DateTime get yesterday => DateTime.now().previousDay.dateOnly;

  /// Get age of an person from `dob`
  int get age {
    final DateTime currentDate = DateTime.now();
    int age = currentDate.year - year;

    // Check if the birthday has already occurred this year
    if (currentDate.month < month ||
        (currentDate.month == month && currentDate.day < day)) {
      age--;
    }

    return age;
  }
}

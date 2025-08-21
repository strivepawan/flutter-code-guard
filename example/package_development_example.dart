// Package Development Example
// This example shows how to use Flutter Code Guard when developing Flutter packages

/// A simple utility package example that demonstrates package development with Flutter Code Guard
library;

// Usage Instructions for Package Development:
// 1. Create a package: flutter create --template=package awesome_utils
// 2. Add this as lib/awesome_utils.dart
// 3. Create the src files below
// 4. Run: flutter_code_guard --watch
// 5. Develop your package with real-time feedback

/// Utility functions for string manipulation
class StringUtils {
  /// Capitalizes the first letter of a string
  static String capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  /// Reverses a string
  static String reverse(String input) {
    return input.split('').reversed.join('');
  }

  /// Checks if a string is a palindrome
  static bool isPalindrome(String input) {
    final cleaned = input.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    return cleaned == reverse(cleaned).toLowerCase();
  }

  /// Converts a string to snake_case
  static String toSnakeCase(String input) {
    return input
        .replaceAll(RegExp(r'([A-Z])'), '_\$1')
        .toLowerCase()
        .replaceAll(RegExp(r'^_'), '');
  }
}

/// Utility functions for date manipulation
class DateUtils {
  /// Formats a DateTime to a readable string
  static String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  /// Checks if a date is in the past
  static bool isPast(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  /// Gets the number of days between two dates
  static int daysBetween(DateTime date1, DateTime date2) {
    return date1.difference(date2).inDays.abs();
  }

  /// Checks if a year is a leap year
  static bool isLeapYear(int year) {
    return (year % 4 == 0) && (year % 100 != 0 || year % 400 == 0);
  }
}

/// Simple example usage
void main() {
  // String utilities
  print(StringUtils.capitalize('hello world')); // Hello world
  print(StringUtils.reverse('dart')); // trad
  print(StringUtils.isPalindrome('racecar')); // true
  print(StringUtils.toSnakeCase('CamelCaseString')); // camel_case_string

  // Date utilities
  final now = DateTime.now();
  print(DateUtils.formatDate(now));
  print(DateUtils.isPast(DateTime(2020, 1, 1))); // true
  print(DateUtils.daysBetween(now, DateTime(2024, 1, 1)));
  print(DateUtils.isLeapYear(2024)); // true
}

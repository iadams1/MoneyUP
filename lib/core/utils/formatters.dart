import 'package:intl/intl.dart';

class Formatters {
  Formatters._(); // prevents instantiation

  static final NumberFormat _currency =
      NumberFormat.currency(locale: 'en_US', symbol: '\$', decimalDigits: 2);

  static final NumberFormat _comma =
      NumberFormat('#,###');

  static String currency(num? value) {
    return _currency.format(value ?? 0);
  }

  static String comma(num? value) {
    return _comma.format(value ?? 0);
  }

  static String getFormattedDate() {
    final now = DateTime.now();

    final weekday = DateFormat('EEEE').format(now);   // Tuesday
    final month = DateFormat('MMMM').format(now);     // March
    final day = now.day;
    final year = now.year;

    return "$weekday, $month $day${_ordinal(day)}, $year";
  }

  static String _ordinal(int day) {
    if (day >= 11 && day <= 13) return "th";

    switch (day % 10) {
      case 1:
        return "st";
      case 2:
        return "nd";
      case 3:
        return "rd";
      default:
        return "th";
    }
  }

  static String formatCategoryTitle(String title) {
    String formatted = title.replaceAll('_', ' ');

    formatted = formatted.replaceAll(
      RegExp(r'\band\b', caseSensitive: false),
      '&',
    );

    formatted = formatted.toLowerCase();

    formatted = formatted
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          if (word == '&') return word;
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');

    return formatted;
  }

  static String category(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    
    return raw
      .toLowerCase().replaceAll('_', ' ').split(' ')
      .map((word) => word.isEmpty ? '' : word[0].toUpperCase()+word.substring(1)).join(' ');
  }
}

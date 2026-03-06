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

  static String category(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    
    return raw
      .toLowerCase().replaceAll('_', ' ').split(' ')
      .map((word) => word.isEmpty ? '' : word[0].toUpperCase()+word.substring(1)).join(' ');
  }
}
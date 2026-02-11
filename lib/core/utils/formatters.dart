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
}

import 'package:intl/intl.dart';

class DateHelper {
  static String formatReadable(String dateString) {
    final DateTime parsedDate = DateTime.parse(dateString);

    return DateFormat('MMMM d, yyyy').format(parsedDate);
  }
}
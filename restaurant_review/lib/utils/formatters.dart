import 'package:intl/intl.dart';

class NumberFormatterUtils {
  /// Format a number or string to currency style with customizable separators
  static String formatToCurrency(dynamic number,
      {String separator = ',', int decimalDigits = 2}) {
    if (number == null) return '';

    // Ensure the input is a valid number
    double value;
    if (number is String) {
      value =
          double.tryParse(number.replaceAll(',', '').replaceAll('.', '')) ?? 0;
    } else if (number is num) {
      value = number.toDouble();
    } else {
      return ''; // Invalid input
    }

    // Define the number format
    NumberFormat numberFormat = NumberFormat.currency(
      symbol: '', // No currency symbol
      decimalDigits: decimalDigits,
      customPattern: separator == '.' ? '#,###'.replaceAll(',', '.') : '#,###',
    );

    // Format the number and return
    return numberFormat.format(value);
  }
}

class DateTimeFormatterUtils {
  /// Function to format DateTime based on the provided template
  static String formatDateTime(DateTime dateTime, String template) {
    bool is24HourFormat = template.contains('24');

    // Strip out '24' or '12' from the template
    template = template.replaceAll(' 24', '').replaceAll(' 12', '');

    // Handle time format
    String timeFormat = is24HourFormat ? 'HH:mm' : 'hh:mm a';
    template = template.replaceAll('hh:mm', timeFormat);

    // Use intl DateFormat to format the DateTime
    DateFormat dateFormat = DateFormat(template);

    return dateFormat.format(dateTime);
  }

  /// Function to format only Date (ignores time)
  static String formatDateOnly(DateTime dateTime, String template) {
    DateFormat dateFormat = DateFormat(template);
    return dateFormat.format(dateTime);
  }

  /// Function to format only Time (ignores date)
  static String formatTimeOnly(DateTime dateTime, {bool is24Hour = true}) {
    String timeFormat = is24Hour ? 'HH:mm' : 'hh:mm a';
    DateFormat timeFormatter = DateFormat(timeFormat);
    return timeFormatter.format(dateTime);
  }
}

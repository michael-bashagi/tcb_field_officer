import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static final RegExp tanzaniaPhoneRegex =
      RegExp(r'^(?:\+?255|0)?([67]\d{8})$');

  static bool isValidTanzaniaPhone(String phone) {
    return tanzaniaPhoneRegex.hasMatch(phone.replaceAll(' ', ''));
  }

  static String normalizeToE164(String phone) {
    final cleanDigits = phone.replaceAll(RegExp(r'\D'), '');
    if (cleanDigits.startsWith('0')) {
      return '+255${cleanDigits.substring(1)}';
    } else if (cleanDigits.startsWith('255')) {
      return '+$cleanDigits';
    } else if (cleanDigits.length == 9) {
      return '+255$cleanDigits';
    }
    return phone;
  }

  static String formatPhoneNumber(String phone) {
    final cleanNumber = normalizeToE164(phone).replaceAll('+', '');

    if (cleanNumber.length == 12 && cleanNumber.startsWith('255')) {
      final country = cleanNumber.substring(0, 3);
      final prefix = cleanNumber.substring(3, 6);
      final mid = cleanNumber.substring(6, 9);
      final end = cleanNumber.substring(9, 12);
      return '+$country $prefix $mid $end';
    }

    return phone;
  }

  static String formatCurrency(double amount,
      {String symbol = 'TZS', bool symbolAtEnd = false}) {
    final formatter = NumberFormat('#,##0', 'en_US');
    final formattedValue = formatter.format(amount);
    return symbolAtEnd ? '$formattedValue $symbol' : '$symbol $formattedValue';
  }

  static String formatControlNumber(String controlNumber) {
    final clean = controlNumber.replaceAll(RegExp(r'\D'), '');
    if (clean.length >= 12) {
      final buffer = StringBuffer();
      for (int i = 0; i < clean.length; i++) {
        if (i > 0 && i % 4 == 0) buffer.write(' ');
        buffer.write(clean[i]);
      }
      return buffer.toString();
    }
    return controlNumber;
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }
}

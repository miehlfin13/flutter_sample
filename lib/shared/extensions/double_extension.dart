import 'package:intl/intl.dart';

extension DoubleExtension on double {
  String toFormatted() {
    final number = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 2,
    );
    return number.format(this);
  }
}

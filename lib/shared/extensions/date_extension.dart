import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  String format(String format) {
    final date = DateFormat(format);
    return date.format(this);
  }

  String toDefaultFormat() {
    final date = DateFormat('dd MMMM yyyy');
    return date.format(this);
  }

  DateTime addYears(int years) {
    return addDays(365 * years).add(Duration(hours: 6 * years));
  }

  DateTime addDays(int days) {
    return add(Duration(days: days));
  }
}

import 'package:mp2_tracker/modules/accounts/dto/monthly_data.dart';

class YearlyData {
  final int year;
  final double rate;
  List<MonthlyData> monthly = [];

  YearlyData({
    required this.year,
    required this.rate
  });
}
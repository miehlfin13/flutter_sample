import 'package:mp2_tracker/modules/accounts/enums/data_status.dart';

class MonthlyData {
  final int year;
  final int month;
  double amount;
  double dividend;
  DataStatus contributionStatus;
  DataStatus dividendStatus;

  MonthlyData({
    required this.year,
    required this.month,
    this.contributionStatus = DataStatus.none,
    this.dividendStatus = DataStatus.none,
    this.amount = 0.00,
    this.dividend = 0.00
  });
}
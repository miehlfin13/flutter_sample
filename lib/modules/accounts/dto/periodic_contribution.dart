import 'package:mp2_tracker/modules/accounts/entity/account.dart';
import 'package:mp2_tracker/modules/accounts/enums/contribution_type.dart';

class PeriodicContribution {
  Account? account;
  double amount;
  final DateTime date;
  final DateTime startDate;
  final DateTime endDate;
  final ContributionType type;
  final int dayOfWeek;
  final int monthOfYear;
  final int dayOfMonth;

  PeriodicContribution({
    this.account,
    this.amount = 0,
    required this.date,
    required this.startDate,
    required this.endDate,
    required this.type,
    this.dayOfWeek = 1,
    this.monthOfYear = 1,
    this.dayOfMonth = 1
  });
}


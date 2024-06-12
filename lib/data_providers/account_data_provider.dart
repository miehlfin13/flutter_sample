import 'package:flutter/material.dart';
import 'package:mp2_tracker/modules/accounts/entity/account.dart';
import 'package:mp2_tracker/modules/accounts/entity/contribution.dart';
import 'package:mp2_tracker/modules/accounts/enums/account_status.dart';
import 'package:mp2_tracker/modules/accounts/services/account_service.dart';

class AccountDataProvider {
  static Future<void> initializeTestData() async {
    final service = AccountService();
    await _testRetirementAccount(service);
    await _testEducation(service);
    await _testVacation(service);
    await _testForecasted1(service);
    await _testForecasted2(service);
  }

  static Future<void> _testRetirementAccount(AccountService service) async {
    int id = await service.createAccount(account: Account(
      name: 'Retirement',
      number: '660005465232',
      isYearlyPayout: false,
      startDate: DateTime.parse('2023-09-20'),
      maturityDate: DateTime.parse('2028-09-19'),
      icon: Icons.house
    ));

    await service.createContribution(contribution: Contribution(accountId: id, amount: 500.00, date: DateTime.parse('2023-09-26')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 10000.00, date: DateTime.parse('2023-09-28')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 500.00, date: DateTime.parse('2023-09-28')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 500.00, date: DateTime.parse('2023-09-30')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 50000.00, date: DateTime.parse('2023-10-02')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 100000.00, date: DateTime.parse('2023-10-04')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 38500.00, date: DateTime.parse('2023-10-06')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 50000.00, date: DateTime.parse('2023-10-26')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 35000.00, date: DateTime.parse('2023-11-01')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 65000.00, date: DateTime.parse('2023-11-27')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 50000.00, date: DateTime.parse('2023-11-27')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 50000.00, date: DateTime.parse('2023-11-28')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 50000.00, date: DateTime.parse('2023-11-29')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 50000.00, date: DateTime.parse('2023-11-30')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 50000.00, date: DateTime.parse('2023-11-30')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 35000.00, date: DateTime.parse('2023-12-01')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 25000.00, date: DateTime.parse('2023-12-31')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 35000.00, date: DateTime.parse('2024-01-01')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 55000.00, date: DateTime.parse('2024-01-31')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 50000.00, date: DateTime.parse('2024-01-31')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 35000.00, date: DateTime.parse('2024-02-01')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 25000.00, date: DateTime.parse('2024-02-28')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 35000.00, date: DateTime.parse('2024-03-01')));
  }

  static Future<void> _testEducation(AccountService service) async {
    int id = await service.createAccount(account: Account(
      name: 'Education',
      number: '352814163891',
      isYearlyPayout: false,
      startDate: DateTime.parse('2021-03-17'),
      maturityDate: DateTime.parse('2026-03-16'),
      targetAmount: 2000000.00,
      icon: Icons.school
    ));

    await service.createContribution(contribution: Contribution(accountId: id, amount: 15000.00, date: DateTime.parse('2021-04-01')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 50000.00, date: DateTime.parse('2021-05-01')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 50000.00, date: DateTime.parse('2021-07-01')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 50000.00, date: DateTime.parse('2021-09-01')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 50000.00, date: DateTime.parse('2021-12-01')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 200000.00, date: DateTime.parse('2021-12-31')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 50000.00, date: DateTime.parse('2022-03-01')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 50000.00, date: DateTime.parse('2022-07-01')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 50000.00, date: DateTime.parse('2022-10-01')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 50000.00, date: DateTime.parse('2022-12-01')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 200000.00, date: DateTime.parse('2022-12-31')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 30000.00, date: DateTime.parse('2023-06-01')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 50000.00, date: DateTime.parse('2023-10-01')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 50000.00, date: DateTime.parse('2023-12-01')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 200000.00, date: DateTime.parse('2023-12-31')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 50000.00, date: DateTime.parse('2024-02-01')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 50000.00, date: DateTime.parse('2024-03-01')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 50000.00, date: DateTime.parse('2024-12-01')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 200000.00, date: DateTime.parse('2024-12-31')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 10000.00, date: DateTime.parse('2025-04-17')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 10000.00, date: DateTime.parse('2025-07-02')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 10000.00, date: DateTime.parse('2025-08-02')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 10000.00, date: DateTime.parse('2025-09-02')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 10000.00, date: DateTime.parse('2025-10-02')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 10000.00, date: DateTime.parse('2025-11-02')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 50000.00, date: DateTime.parse('2025-12-01')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 200000.00, date: DateTime.parse('2025-12-31')));
  }
  
  static Future<void> _testVacation(AccountService service) async {
    int id = await service.createAccount(account: Account(
      name: 'Vacation',
      number: '817264081238',
      isYearlyPayout: false,
      startDate: DateTime.parse('2018-02-24'),
      maturityDate: DateTime.parse('2023-02-23'),
      targetAmount: 100000.00,
      icon: Icons.beach_access
    ));

    await service.createContribution(contribution: Contribution(accountId: id, amount: 15000.00, date: DateTime.parse('2018-06-02')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 10000.00, date: DateTime.parse('2018-11-21')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 35000.00, date: DateTime.parse('2020-12-29')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 20000.00, date: DateTime.parse('2021-03-15')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 5000.00, date: DateTime.parse('2022-08-05')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 5000.00, date: DateTime.parse('2022-10-03')));
    await service.createContribution(contribution: Contribution(accountId: id, amount: 10000.00, date: DateTime.parse('2023-02-14')));
  }

  static Future<void> _testForecasted1(AccountService service) async {
    await service.createAccount(account: Account(
      name: 'Forecasted_20240301132654',
      isYearlyPayout: false,
      startDate: DateTime.parse('2024-03-01'),
      maturityDate: DateTime.parse('2029-02-28'),
      targetAmount: 1000000.00
    ));
  }

  static Future<void> _testForecasted2(AccountService service) async {
    int id = await service.createAccount(account: Account(
      name: 'Forecasted_20240310082137',
      isYearlyPayout: true,
      startDate: DateTime.parse('2025-01-01'),
      maturityDate: DateTime.parse('2029-12-31'),
      status: AccountStatus.inactive,
      deletedDate: DateTime.tryParse('2024-02-11')
    ));

    await service.createContribution(contribution: Contribution(accountId: id, amount: 10000000.00, date: DateTime.parse('2025-01-01')));
  }
}
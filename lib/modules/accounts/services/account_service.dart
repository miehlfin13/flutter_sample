import 'package:mp2_tracker/modules/accounts/dto/monthly_data.dart';
import 'package:mp2_tracker/modules/accounts/dto/periodic_contribution.dart';
import 'package:mp2_tracker/modules/accounts/dto/yearly_data.dart';
import 'package:mp2_tracker/modules/accounts/entity/account.dart';
import 'package:mp2_tracker/modules/accounts/entity/contribution.dart';
import 'package:mp2_tracker/modules/accounts/entity/custom_dividend.dart';
import 'package:mp2_tracker/modules/accounts/enums/account_status.dart';
import 'package:mp2_tracker/modules/accounts/enums/contribution_type.dart';
import 'package:mp2_tracker/modules/accounts/enums/data_status.dart';
import 'package:mp2_tracker/modules/dividends/entity/dividend.dart';
import 'package:mp2_tracker/modules/dividends/services/dividend_service.dart';
import 'package:mp2_tracker/shared/extensions/date_extension.dart';
import 'package:mp2_tracker/shared/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class AccountService {
  final accountsTableName = 'accounts';
  final contributionsTableName = 'contributions';
  final customDividendsTableName = 'custom_dividends';

  Future<void> createTable(Database database) async {
    await _createAccountsTable(database);
    await _createContributionsTable(database);
    await _createCustomDividends(database);
  }

  Future<void> _createAccountsTable(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS $accountsTableName (
        "id" INTEGER NOT NULL,
        "name" TEXT NOT NULL,
        "number" TEXT,
        "isYearlyPayout" INTEGER NOT NULL,
        "startDate" INTEGER NOT NULL,
        "maturityDate" INTEGER NOT NULL,
        "claimDate" INTEGER,
        "deletedDate" INTEGER,
        "targetAmount" REAL,
        "icon" INTEGER NOT NULL,
        "status" INTEGER NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT)
      )''');
  }

  Future<void> _createContributionsTable(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS $contributionsTableName (
        "id" INTEGER NOT NULL,
        "accountId" INTEGER NOT NULL,
        "amount" REAL NOT NULL,
        "date" INTEGER NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT),
        FOREIGN KEY(accountId) REFERENCES accounts(id)
          ON DELETE CASCADE
          ON UPDATE CASCADE
      )''');
  }

  Future<void> _createCustomDividends(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS $customDividendsTableName (
        "id" INTEGER NOT NULL,
        "accountId" INTEGER NOT NULL,
        "year" INTEGER NOT NULL,
        "rate" REAL NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT),
        FOREIGN KEY(accountId) REFERENCES accounts(id)
          ON DELETE CASCADE
          ON UPDATE CASCADE
      )''');
  }

  Future<int> createAccount({required Account account}) async {
    final database = await DatabaseService().database;
    int accountId = await database.insert(
      accountsTableName,
      account.toSqflite(),
      conflictAlgorithm: ConflictAlgorithm.rollback
    );

    final dividends = await DividendService().fetchAll(account.startDate.year);

    for (var year = account.startDate.year; year <= account.maturityDate.year; year++) {
      final dividend = dividends.firstWhere(
        (dividend) => dividend.year == year,
        orElse: () => Dividend(id: 0, year: year, rate: 6.00));

      await createCustomDividend(customDividend: CustomDividend(
        accountId: accountId,
        year: year,
        rate: dividend.rate
      ));
    }

    return accountId;
  }

  Future<void> updateAccount({required Account account}) async {
    final database = await DatabaseService().database;
    await database.update(
      accountsTableName,
      account.toSqflite(),
      where: 'id = ?',
      whereArgs: [account.id],
      conflictAlgorithm: ConflictAlgorithm.rollback
    );
  }

  Future<List<Account>> fetchAllAccounts([AccountStatus? status]) async {
    final database = await DatabaseService().database;
    final orderBy = switch (status) {
      AccountStatus.claimed => 'claimDate DESC',
      AccountStatus.inactive => 'deletedDate DESC',
      _ => 'startDate'
    };

    final accounts = await database.query(
      accountsTableName,
      orderBy: orderBy,
      where: status == null ? '' : 'status = ?',
      whereArgs: status == null ? null : [status.index]
    );
    return accounts.map((account) => Account.fromSqflite(account)).toList();
  }

  Future<void> deleteAccount(int accountId, {void Function()? callback}) async {
    final database = await DatabaseService().database;
    await database.rawUpdate(
      'UPDATE $accountsTableName SET status = ?, deletedDate = ? WHERE id = ?',
      [AccountStatus.inactive.index, DateTime.now().millisecondsSinceEpoch, accountId]
    );

    if (callback != null) {
      callback();
    }
  }

  Future<void> purgeAccount(int accountId, {void Function()? callback}) async {
    final database = await DatabaseService().database;
    await database.delete(
      accountsTableName,
      where: 'id = ?',
      whereArgs: [accountId]
    );
    
    if (callback != null) {
      callback();
    }
  }

  Future<void> claim(int accountId, {void Function()? callback}) async {
    final database = await DatabaseService().database;
    await database.rawUpdate(
      'UPDATE $accountsTableName SET status = ?, claimDate = ? WHERE id = ?',
      [AccountStatus.claimed.index, DateTime.now().millisecondsSinceEpoch, accountId]
    );

    if (callback != null) {
      callback();
    }
  }

  Future<void> createContribution({required Contribution contribution}) async {
    final database = await DatabaseService().database;
    contribution.id = await database.insert(
      contributionsTableName,
      contribution.toSqflite(),
      conflictAlgorithm: ConflictAlgorithm.rollback
    );
  }

  Future<void> createPeriodicContributions(PeriodicContribution periodicContribution) async {
    DateTime current = periodicContribution.startDate;
    while (current.isBefore(periodicContribution.endDate.addDays(1))) {
      final contribution = Contribution(
        accountId: periodicContribution.account!.id,
        amount: periodicContribution.amount,
        date: current
      );

      if (periodicContribution.type == ContributionType.weekly && current.weekday == periodicContribution.dayOfWeek) {
        createContribution(contribution: contribution);
        periodicContribution.account!.contributions.add(contribution);
      } else if ((periodicContribution.type == ContributionType.monthly) || (periodicContribution.type == ContributionType.yearly && current.month == periodicContribution.monthOfYear)) {
        if (periodicContribution.dayOfMonth > 28 && current.addDays(1).month != current.month) {
          createContribution(contribution: contribution);
          periodicContribution.account!.contributions.add(contribution);
        } else if (periodicContribution.dayOfMonth == current.day) {
          createContribution(contribution: contribution);
          periodicContribution.account!.contributions.add(contribution);
        }
      }
      current = current.addDays(1);
    }
  }

  Future<List<Contribution>> fetchAllContributions(int accountId, {int? year, int? month}) async {
    final database = await DatabaseService().database;

    String where = 'accountId = ?';
    List<Object> whereArgs = [accountId];

    if (year != null) {
      where += ' AND strftime(\'%Y\', datetime(date / 1000, \'unixepoch\', \'localtime\')) = ?';
      whereArgs.add(year.toString());
    }

    if (month != null) {
      where += ' AND strftime(\'%m\', datetime(date / 1000, \'unixepoch\', \'localtime\')) = ?';
      whereArgs.add(month.toString().padLeft(2, '0'));
    }

    final contributions = await database.query(
      contributionsTableName,
      where: where,
      whereArgs: whereArgs,
      orderBy: 'date'
    );
    return contributions.map((contribution) => Contribution.fromSqflite(contribution)).toList();
  }

  Future<void> deleteContribution(int contributionId, {void Function()? callback}) async {
    final database = await DatabaseService().database;
    await database.delete(
      contributionsTableName,
      where: 'id = ?',
      whereArgs: [contributionId]
    );
    
    if (callback != null) {
      callback();
    }
  }

  Future<int> createCustomDividend({required CustomDividend customDividend}) async {
    final database = await DatabaseService().database;
    return await database.insert(
      customDividendsTableName,
      customDividend.toSqflite(),
      conflictAlgorithm: ConflictAlgorithm.rollback
    );
  }

  Future<void> updateCustomDividend(CustomDividend customDividend, {void Function()? callback}) async {
    final database = await DatabaseService().database;
    await database.rawUpdate(
      'UPDATE $customDividendsTableName SET rate = ? WHERE accountId = ? AND year = ?',
      [customDividend.rate, customDividend.accountId, customDividend.year]
    );

    if (callback != null) {
      callback();
    }
  }

  Future<List<CustomDividend>> fetchAllCustomDividends(int accountId) async {
    final database = await DatabaseService().database;
    final customDividends = await database.query(
      customDividendsTableName,
      where: 'accountId = ?',
      whereArgs: [accountId],
      orderBy: 'year'
    );
    return customDividends.map((customDividend) => CustomDividend.fromSqflite(customDividend)).toList();
  }

  Future<void> purgeCustomDividends(int lastDeclaredYear, {void Function()? callback}) async {
    final database = await DatabaseService().database;
    await database.delete(
      customDividendsTableName,
      where: 'year <= ?',
      whereArgs: [lastDeclaredYear]
    );
    
    if (callback != null) {
      callback();
    }
  }

  Future<List<YearlyData>> calculate(Account account) async {
    List<YearlyData> yearlyDatas = [];
    
    try{
      final dividends = await DividendService().fetchAll();
      final customDividends = await fetchAllCustomDividends(account.id);
      var prevYearTotalAmount = 0.00;

      for (var year = account.startDate.year; year <= account.maturityDate.year; year++) {
        final dividend = _getDividendByYear(year, dividends);
        final lastDeclaredYear = dividends.first.year;

        final rate = dividend != null
          ? dividend.rate
          : customDividends.where((customDividend) => customDividend.year == year).first.rate;

        var yearly = YearlyData(
          year: year,
          rate: rate
        );

        var prevStatus = DataStatus.declared;
        if (year == account.startDate.year) {
          prevStatus = DataStatus.none;
        } else if (year > lastDeclaredYear + 1) {
          prevStatus = DataStatus.forecasted;
        }
        
        yearly.monthly.add(MonthlyData(
          year: year,
          month: 0,
          contributionStatus: prevStatus,
          dividendStatus: _getDividendStatus(year, 1, account, lastDeclaredYear),
          amount: prevYearTotalAmount,
          dividend: _calculateDividend(
            year,
            1,
            yearly.rate,
            prevYearTotalAmount,
            account.maturityDate
          )
        ));

        _calculateByYear(yearly, account, lastDeclaredYear);
        yearlyDatas.add(yearly);

        prevYearTotalAmount = yearly.monthly.fold(0.00, (total, contribution) => total + contribution.amount);

        if (!account.isYearlyPayout) {
          prevYearTotalAmount += yearly.monthly.fold(0.00, (total, contribution) => total + contribution.dividend);
        }  
      }
    } catch (e) {
      // Bad state: No element
      // Error shows when no existing active account
    }
    return yearlyDatas;
  }

  double calculateTotalContributions(Iterable<YearlyData> yearlyDatas) {
    return (
      yearlyDatas.map((yearly)
        => yearly.monthly.where(
            (contribution) => contribution.month > 0
              && contribution.contributionStatus == DataStatus.declared
          ).fold(0.00, (total, monthlyContribution) => total + monthlyContribution.amount))
      ).fold(0.00, (total, yearlyContribution) => total + yearlyContribution);
  }
  
  double calculateTotalDividends(Iterable<YearlyData> yearlyDatas) {
    return (
      yearlyDatas.map((yearly)
        => yearly.monthly.where(
          (contribution) => contribution.dividendStatus == DataStatus.declared
        ).fold(0.00, (total, monthlyContribution) => total + monthlyContribution.dividend))
      ).fold(0.00, (total, yearlyDividends) => total + yearlyDividends);
  }

  double calculateTotalForecastedContributions(Iterable<YearlyData> yearlyDatas) {
    return (
      yearlyDatas.map((yearly)
        => yearly.monthly.where(
            (contribution) => contribution.month > 0
          ).fold(0.00, (total, monthlyContribution) => total + monthlyContribution.amount))
      ).fold(0.00, (total, yearlyContribution) => total + yearlyContribution);
  }

  double calculateTotalForecastedDividends(Iterable<YearlyData> yearlyDatas) {
    return (
      yearlyDatas.map((yearly)
        => yearly.monthly.fold(0.00, (total, monthlyContribution) => total + monthlyContribution.dividend))
      ).fold(0.00, (total, yearlyDividends) => total + yearlyDividends);
  }

  Dividend? _getDividendByYear(int year, List<Dividend> dividends) {
    return dividends.where((dividend) => dividend.year == year).firstOrNull;
  }

  void _calculateByYear(YearlyData yearly, Account account, int lastDeclaredYear) {
    for (var month = 1; month <= 12; month++) {
      final contributions = account.contributions.where(
        (contribution) => contribution.date.year == yearly.year && contribution.date.month == month
      );

      yearly.monthly.add(MonthlyData(
        year: yearly.year,
        month: month,
        contributionStatus: _getContributionStatus(yearly.year, month, account, lastDeclaredYear),
        dividendStatus: _getDividendStatus(yearly.year, month, account, lastDeclaredYear),
        amount: contributions.fold(0.00, (total, contribution) => total + contribution.amount),
        dividend: contributions.fold(0.00, (total, contribution) {
          return total + _calculateDividend(
            yearly.year,
            month,
            yearly.rate,
            contribution.amount,
            account.maturityDate
          );
        })
      ));
    }
  }

  double _calculateDividend(int year, int month, double rate, double amount,DateTime maturityDate) {
    double multiplier;
    if (year == maturityDate.year) {
      multiplier = (maturityDate.month - month + 1) / 12;
    } else {
      multiplier = (13 - month) / 12;
    }
    return amount * rate * multiplier / 100.00;
  }

  DataStatus _getContributionStatus(int year, int month, Account account, int lastDeclaredYear) {
    DataStatus status = DataStatus.declared;
    
    final currentYear = DateTime.now().year;
    final currentMonth = DateTime.now().month;
    if (year > currentYear || (year == currentYear && month > currentMonth)) {
      status = DataStatus.forecasted;
    }

    if (year == account.maturityDate.year && month > account.maturityDate.month) {
      status = DataStatus.none;
    }
  
    if (year == account.startDate.year && month < account.startDate.month) {
      status = DataStatus.none;
    }

    return status;
  }

  DataStatus _getDividendStatus(int year, int month, Account account, int lastDeclaredYear) {
    DataStatus status = DataStatus.declared;
    if (account.status != AccountStatus.claimed) {
      if (year == account.startDate.year && month < account.startDate.month) {
        status = DataStatus.none;
      }

      if (year > lastDeclaredYear) {
        status = DataStatus.forecasted;
      }

      if (year == account.maturityDate.year && month > account.maturityDate.month) {
        status = DataStatus.none;
      }
    }
  
    return status;
  }
}

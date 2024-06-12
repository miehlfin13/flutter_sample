import 'package:flutter/material.dart';
import 'package:mp2_tracker/modules/accounts/dto/forecast.dart';
import 'package:mp2_tracker/modules/accounts/dto/periodic_contribution.dart';
import 'package:mp2_tracker/modules/accounts/entity/account.dart';
import 'package:mp2_tracker/modules/accounts/entity/contribution.dart';
import 'package:mp2_tracker/modules/accounts/enums/contribution_type.dart';
import 'package:mp2_tracker/modules/accounts/screens/account_view.dart';
import 'package:mp2_tracker/modules/accounts/services/account_service.dart';
import 'package:mp2_tracker/modules/forecast/enums/forecast_type.dart';
import 'package:mp2_tracker/modules/notifications/entity/notification_message.dart';
import 'package:mp2_tracker/modules/notifications/services/notification_service.dart';
import 'package:mp2_tracker/shared/constants/app.dart';
import 'package:mp2_tracker/shared/extensions/date_extension.dart';
import 'package:mp2_tracker/shared/extensions/forecast_type_extension.dart';
import 'package:mp2_tracker/shared/services/ad_service.dart';
import 'package:mp2_tracker/shared/tools/dialog_provider.dart';
import 'package:mp2_tracker/shared/tools/navigate.dart';
import 'package:mp2_tracker/shared/widgets/fields/amount_field.dart';
import 'package:mp2_tracker/shared/widgets/fields/contribution_type_field.dart';
import 'package:mp2_tracker/shared/widgets/fields/date_field.dart';
import 'package:mp2_tracker/shared/widgets/fields/month_day_field.dart';
import 'package:mp2_tracker/shared/widgets/fields/month_field.dart';
import 'package:mp2_tracker/shared/widgets/fields/standard_dropdown_field.dart';
import 'package:mp2_tracker/shared/widgets/fields/week_day_field.dart';
import 'package:mp2_tracker/shared/widgets/templates/standard_template.dart';

class AddForecast extends StatefulWidget {
  const AddForecast({super.key});

  @override
  State<StatefulWidget> createState() => _AddForecastState();
}

class _AddForecastState extends State<AddForecast> {
  final service = AccountService();
  var forecastType = ForecastType.periodicContribution;
  final startDateController = TextEditingController();
  var startDateValue = '';

  ContributionType contributionType = ContributionType.monthly;
  int dayOfWeek = 1;
  int dayOfMonth = 1;
  int monthOfYear = 1;

  int years = 5;
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AdService.createRewardedAd();

    return StandardTemplate(
      title: 'Add New Forecast',
      content: [
        StandardDropDownField(
          label: 'Forecast Type',
          icon: Icons.show_chart,
          value: forecastType,
          items: const [
            DropdownMenuItem(value: ForecastType.periodicContribution, child: Text('Periodic Contribution')),
            DropdownMenuItem(value: ForecastType.oneTimePayment, child: Text('One-time Payment')),
            DropdownMenuItem(value: ForecastType.targetAmount, child: Text('Target Amount'))
          ],
          onChanged: (value) => setState(() => forecastType = value)
        ),
        DateField(
          context: context,
          label: 'Start Date',
          icon: Icons.today,
          controller: startDateController,
          onSelect: (value) => setState(() {
            startDateController.text = value.toDefaultFormat();
            startDateValue = value.format('yyyy-MM-dd');
          }),
          onCancel: () => setState(() {
            startDateController.text = '';
            startDateValue = '';
          })
        ),
        Visibility(
          visible: forecastType == ForecastType.periodicContribution,
          child: Column(children: [
            ContributionTypeField(
              initialValue: ContributionType.monthly,
              isDayIncluded: false,
              onChanged: (value) => setState(() => contributionType = value)
            ),
            Visibility(
              visible: contributionType == ContributionType.weekly,
              child: WeekDayField(
                onChanged: (value) => setState(() => dayOfWeek = value)
              )
            ),
            Visibility(
              visible: contributionType == ContributionType.yearly,
              child: MonthField(
                onChanged: (value) => setState(() => monthOfYear = value)
              )
            ),
            Visibility(
              visible: contributionType == ContributionType.monthly || contributionType == ContributionType.yearly,
              child: MonthDayField(
                onChanged: (value) => setState(() => dayOfMonth = value)
              )
            )
          ])
        ),
        AmountField(
          label: forecastType == ForecastType.targetAmount ? 'Approximate Target Amount' : 'Amount',
          controller: amountController
        )
      ],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final startDate = DateTime.tryParse(startDateValue);
          final maturityDate = (startDate ?? DateTime.now()).addYears(5);
          final amount = double.tryParse(amountController.text);
          final minAmount = forecastType == ForecastType.targetAmount ? 50000.0 : App.minimumContribution;

          if (startDate == null) {
            DialogProvider.validationError(
              context: context,
              content: 'Start Date is required.'
            );
            return;
          } else if (amountController.text.isEmpty) {
            DialogProvider.validationError(
              context: context,
              content: 'Amount is required.'
            );
            return;
          } else if (amount! < minAmount) {
            DialogProvider.validationError(
              context: context,
              content: 'Minimum amount is $minAmount'
            );
            return;
          }

          if (forecastType == ForecastType.oneTimePayment) {
            _createOneTimePaymentForecast(startDate: startDate, maturityDate: maturityDate, amount: amount);
          } else if (forecastType == ForecastType.periodicContribution) {
            _createPeriodicContributionForecast(startDate: startDate, maturityDate: maturityDate, amount: amount);
          } else if (forecastType == ForecastType.targetAmount) {
            _createTargetAmountForecast(startDate: startDate, maturityDate: maturityDate, amount: amount);
          }
        },
        tooltip: 'Save new forecast',
        child: const Icon(Icons.save)
      )
    );
  }

  _createForecastAccount({
    required ForecastType forecastType,
    required DateTime startDate,
    required DateTime maturityDate,
    required void Function(Account account) action
  }) {
    final accountName = 'Forecast_${forecastType.toAcronym()}_${DateTime.now().format('yyyyMMddHHmmss')}';

    final account = Account(
      name: accountName,
      isYearlyPayout: false,
      startDate: startDate,
      maturityDate: maturityDate
    );

    Future.wait([service.createAccount(account: account)])
      .then((value) {
        account.id = value.first;
        action(account);

        NotificationService().createAndNotify(
          context: context,
          notification: NotificationMessage(
            subject: '${forecastType.toLabelString()} Forecast Account Created',
            content: 'Your account (${account.name}) has been successfully created.'
          )
        );
        Navigate.toScreen(
          context,
          AccountView(account: account),
          callback: Navigate.toAccountList(context)
        );
      });
  }

  _executeForecast({
    required DateTime startDate,
    required DateTime maturityDate,
    required void Function(Account account) action
  }) {
    forecastAction() => _createForecastAccount(
      forecastType: forecastType,
      startDate: startDate,
      maturityDate: maturityDate,
      action: (account) => action(account)
    );

    if (App.isPro) {
      forecastAction();
    } else {
      AdService.initializeRewardAd(
        onAdRewarded: () => forecastAction(),
        onAdDismissed: () => DialogProvider.info(
          context: context,
          subject: 'Ad Dismissed',
          content: const Text('Generating forecast failed')
        ),
        onAdFailed: () => DialogProvider.info(
          context: context,
          subject: 'Ad Failed',
          content: const Text('Failed to load ads')
        )
      );
    }
  }
  
  _createOneTimePaymentForecast({
    required DateTime startDate,
    required DateTime maturityDate,
    required double amount
  }) {
    final forecast = Forecast(
      amount: amount,
      startDate: startDate,
      endDate: maturityDate,
      type: forecastType
    );

    DialogProvider.confirmForecast(
      context: context,
      forecast: forecast,
      action: () => _executeForecast(
        startDate: startDate,
        maturityDate: maturityDate,
        action: (account) {
          final contribution = Contribution(
            accountId: account.id,
            amount: amount,
            date: startDate
          );

          service.createContribution(contribution: contribution);
          account.contributions.add(contribution);
        }
      )
    );
  }

  _createPeriodicContributionForecast({
    required DateTime startDate,
    required DateTime maturityDate,
    required double amount
  }) {
    final periodicContribution = PeriodicContribution(
      amount: amount,
      date: DateTime.now(),
      startDate: startDate,
      endDate: maturityDate,
      type: contributionType,
      dayOfWeek: dayOfWeek,
      monthOfYear: monthOfYear,
      dayOfMonth: dayOfMonth
    );

    DialogProvider.confirmPeriodicContribution(
      context: context,
      subject: 'Periodic Contribution Forecast Confirmation',
      content: 'Are you sure you want to add this forecast?',
      periodicContribution: periodicContribution,
      action: () => _executeForecast(
        startDate: startDate,
        maturityDate: maturityDate,
        action: (account) {
          periodicContribution.account = account;
          service.createPeriodicContributions(periodicContribution);
        }
      )
    );
  }

  _createTargetAmountForecast({
    required DateTime startDate,
    required DateTime maturityDate,
    required double amount
  }) {
    final forecast = Forecast(
      amount: amount,
      startDate: startDate,
      endDate: maturityDate,
      type: forecastType
    );

    DialogProvider.confirmForecast(
      context: context,
      forecast: forecast,
      action: () => _executeForecast(
        startDate: startDate,
        maturityDate: maturityDate,
        action: (account) {
          final forecastedMonthlyAmount = (amount * 0.859062857148571) / 60;

          if (startDate.day > 1) {
            final contribution = Contribution(
              accountId: account.id,
              amount: forecastedMonthlyAmount,
              date: startDate
            );

            service.createContribution(contribution: contribution);
            account.contributions.add(contribution);
          }

          service.createPeriodicContributions(PeriodicContribution(
            account: account,
            amount: forecastedMonthlyAmount,
            date: DateTime.now(),
            startDate: startDate,
            endDate: maturityDate,
            type: contributionType,
            dayOfWeek: dayOfWeek,
            monthOfYear: monthOfYear,
            dayOfMonth: dayOfMonth
          ));
        }
      )
    );
  }
}

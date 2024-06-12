import 'package:flutter/material.dart';
import 'package:mp2_tracker/modules/accounts/dto/periodic_contribution.dart';
import 'package:mp2_tracker/modules/accounts/entity/account.dart';
import 'package:mp2_tracker/modules/accounts/entity/contribution.dart';
import 'package:mp2_tracker/modules/accounts/enums/contribution_type.dart';
import 'package:mp2_tracker/modules/accounts/screens/account_view.dart';
import 'package:mp2_tracker/modules/accounts/services/account_service.dart';
import 'package:mp2_tracker/modules/notifications/entity/notification_message.dart';
import 'package:mp2_tracker/modules/notifications/services/notification_service.dart';
import 'package:mp2_tracker/shared/constants/app.dart';
import 'package:mp2_tracker/shared/extensions/date_extension.dart';
import 'package:mp2_tracker/shared/extensions/double_extension.dart';
import 'package:mp2_tracker/shared/extensions/int_extension.dart';
import 'package:mp2_tracker/shared/tools/dialog_provider.dart';
import 'package:mp2_tracker/shared/tools/navigate.dart';
import 'package:mp2_tracker/shared/widgets/fields/amount_field.dart';
import 'package:mp2_tracker/shared/widgets/fields/contribution_type_field.dart';
import 'package:mp2_tracker/shared/widgets/fields/date_field.dart';
import 'package:mp2_tracker/shared/widgets/fields/month_day_field.dart';
import 'package:mp2_tracker/shared/widgets/fields/month_field.dart';
import 'package:mp2_tracker/shared/widgets/fields/week_day_field.dart';
import 'package:mp2_tracker/shared/widgets/templates/standard_template.dart';

class AddContribution extends StatefulWidget {
  const AddContribution({
    super.key,
    required this.account
  });

  final Account account;
  
  @override
  State<StatefulWidget> createState() => _AddContributionState();
}

class _AddContributionState extends State<AddContribution> {
  ContributionType contributionType = ContributionType.day;
  final dateController = TextEditingController();
  String dateValue = '';
  final dateFromController = TextEditingController();
  String dateFromValue = '';
  final dateToController = TextEditingController();
  String dateToValue = '';
  int dayOfWeek = 1;
  int dayOfMonth = 1;
  int monthOfYear = 1;
  final amountController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return StandardTemplate(
      title: 'Add New Contribution',
      content: [
        ContributionTypeField(
          onChanged: (value) => setState(() => contributionType = value)
        ),
        Visibility(
          visible: contributionType == ContributionType.day,
          child: DateField(
            context: context,
            label: 'Date',
            icon: Icons.today,
            controller: dateController,
            firstDate: widget.account.startDate,
            lastDate: widget.account.maturityDate,
            onSelect: (value) => {
              setState(() {
                dateController.text = value.toDefaultFormat();
                dateValue = value.format('yyyy-MM-dd');
              })
            },
            onCancel: () => {
              setState(() {
                dateController.text = '';
                dateValue = '';
              })
            }
          )
        ),
        Visibility(
          visible: contributionType != ContributionType.day,
          child: Column(children: [
            DateField(
              context: context,
              label: 'Date From',
              icon: Icons.today,
              controller: dateFromController,
              firstDate: widget.account.startDate,
              lastDate: widget.account.maturityDate,
              onSelect: (value) => {
                setState(() {
                  dateFromController.text = value.toDefaultFormat();
                  dateFromValue = value.format('yyyy-MM-dd');
                })
              },
              onCancel: () => {
                setState(() {
                  dateFromController.text = '';
                  dateFromValue = '';
                })
              }
            ),
            DateField(
              context: context,
              label: 'Date To',
              icon: Icons.event,
              controller: dateToController,
              firstDate: widget.account.startDate,
              lastDate: widget.account.maturityDate,
              onSelect: (value) => {
                setState(() {
                  dateToController.text = value.toDefaultFormat();
                  dateToValue = value.format('yyyy-MM-dd');
                })
              },
              onCancel: () => {
                setState(() {
                  dateToController.text = '';
                  dateToValue = '';
                })
              }
            )
          ])
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
        ),
        AmountField(controller: amountController)
      ],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final date = DateTime.tryParse(dateValue);
          final dateFrom = DateTime.tryParse(dateFromValue);
          final dateTo = DateTime.tryParse(dateToValue);
          final amount = double.tryParse(amountController.text);

          if (contributionType == ContributionType.day && date == null) {
            DialogProvider.validationError(
              context: context,
              content: 'Date is required.'
            );
          } else if (contributionType != ContributionType.day && dateFrom == null) {
            DialogProvider.validationError(
              context: context,
              content: 'Date From is required.'
            );
          } else if (contributionType != ContributionType.day && dateTo == null) {
            DialogProvider.validationError(
              context: context,
              content: 'Date To is required.'
            );
          } else if (contributionType != ContributionType.day && dateTo!.isBefore(dateFrom!)) {
            DialogProvider.validationError(
              context: context,
              content: 'Date To must be after Date From.'
            );
          } else if (amountController.text.isEmpty) {
            DialogProvider.validationError(
              context: context,
              content: 'Amount is required.'
            );
          } else if (amount! < App.minimumContribution) {
              DialogProvider.validationError(
                context: context,
                content: 'Minimum amount is ${App.minimumContribution}'
              );
          } else {
            final periodicContribution = PeriodicContribution(
              account: widget.account,
              amount: amount,
              date: date ?? DateTime.now(),
              startDate: dateFrom ?? DateTime.now(),
              endDate: dateTo ?? DateTime.now(),
              type: contributionType,
              dayOfWeek: dayOfWeek,
              monthOfYear: monthOfYear,
              dayOfMonth: dayOfMonth
            );

            DialogProvider.confirmPeriodicContribution(
              context: context,
              subject: 'Contribution Confirmation',
              content: 'Are you sure you want to add this contribution?',
              periodicContribution: periodicContribution,
              isForecast: false,
              action: () {
                final service = AccountService();
                if (contributionType == ContributionType.day) {
                  final contribution = Contribution(
                    accountId: widget.account.id,
                    amount: amount,
                    date: date!
                  );
                  Future.wait([service.createContribution(contribution: contribution)])
                    .then((value) {
                      widget.account.contributions.add(contribution);
                    });
                } else {
                  service.createPeriodicContributions(periodicContribution);
                }

                final contributionMessage = switch(contributionType) {
                  ContributionType.day => 'on ${date!.toDefaultFormat()}',
                  ContributionType.weekly => 'weekly every ${dayOfWeek.toFullWeekString()}, from ${dateFrom!.toDefaultFormat()} to ${dateTo!.toDefaultFormat()}',
                  ContributionType.monthly => 'monthly every ${dayOfMonth.toOrdinal()} day, from ${dateFrom!.toDefaultFormat()} to ${dateTo!.toDefaultFormat()}',
                  ContributionType.yearly => 'yearly every ${dayOfMonth.toOrdinal()} day of ${monthOfYear.toFullMonthString()}, from ${dateFrom!.toDefaultFormat()} to ${dateTo!.toDefaultFormat()}'
                };

                NotificationService().createAndNotify(
                  context: context,
                  notification: NotificationMessage(
                    subject: 'Contribution Updated',
                    content:
                      'Your account (${widget.account.name}) contribution has been successfully updated.'
                      '\n'
                      'With an amount of ${amount.toFormatted()} $contributionMessage.'
                  )
                );

                Navigate.toScreen(
                  context,
                  AccountView(account: widget.account),
                  callback: () => Navigate.toAccountList(context)
                );
              }
            );
          }
        },
        tooltip: 'Save new contribution',
        child: const Icon(Icons.save)
      )
    );
  }
}

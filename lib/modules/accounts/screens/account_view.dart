import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mp2_tracker/modules/accounts/dto/monthly_data.dart';
import 'package:mp2_tracker/modules/accounts/dto/yearly_data.dart';
import 'package:mp2_tracker/modules/accounts/entity/account.dart';
import 'package:mp2_tracker/modules/accounts/entity/custom_dividend.dart';
import 'package:mp2_tracker/modules/accounts/enums/account_status.dart';
import 'package:mp2_tracker/modules/accounts/enums/data_status.dart';
import 'package:mp2_tracker/modules/accounts/screens/add_contribution.dart';
import 'package:mp2_tracker/modules/accounts/screens/add_edit_account.dart';
import 'package:mp2_tracker/modules/accounts/screens/contributions_view.dart';
import 'package:mp2_tracker/modules/accounts/services/account_service.dart';
import 'package:mp2_tracker/modules/notifications/entity/notification_message.dart';
import 'package:mp2_tracker/modules/notifications/services/notification_service.dart';
import 'package:mp2_tracker/shared/extensions/date_extension.dart';
import 'package:mp2_tracker/shared/extensions/double_extension.dart';
import 'package:mp2_tracker/shared/extensions/int_extension.dart';
import 'package:mp2_tracker/shared/tools/amount_input_formatter.dart';
import 'package:mp2_tracker/shared/tools/dialog_provider.dart';
import 'package:mp2_tracker/shared/tools/navigate.dart';
import 'package:mp2_tracker/shared/widgets/fields/standard_text_field.dart';
import 'package:mp2_tracker/shared/widgets/label_value.dart';
import 'package:mp2_tracker/shared/widgets/stacked_icon.dart';
import 'package:mp2_tracker/shared/widgets/standard_cell_data.dart';
import 'package:mp2_tracker/shared/widgets/templates/future_template.dart';

class AccountView extends StatefulWidget {
  const AccountView({
    super.key,
    required this.account
  });
  
  final Account account;
  
  @override
  State<StatefulWidget> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final service = AccountService();
  final notificationService = NotificationService();

  @override
  Widget build(BuildContext context) {
    return FutureTemplate(
      title:
        '${widget.account.name}'
        ' ${widget.account.number == '' ? '' : '(${widget.account.number})'}',
      future: service.calculate(widget.account),
      widgetBuild: (yearlyDatas) => [
        Text(
          widget.account.isYearlyPayout ? 'Yearly Payout' : 'Compounding Interest',
          style: const TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.w600
          )
        ),
        Text(
          '${widget.account.startDate.toDefaultFormat()} - ${widget.account.maturityDate.toDefaultFormat()}',
          style: const TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.w600
          )
        ),
        Divider(color: Colors.green.shade900),
        Table(
          border: TableBorder.all(width: 2, borderRadius: BorderRadius.circular(10)),
          children: [
            TableRow(children: [
              _createHeader(label: 'Year'),
              ...yearlyDatas.map((yearly) => _createHeader(label: yearly.year.toString()))
            ]),
            _createRateHeader(yearlyDatas),
            ..._createMonthlyRow(yearlyDatas),
            _createYearlyTotalRow(yearlyDatas),
            _createDividendsRow(yearlyDatas)
          ]
        ),
        _createTotals(yearlyDatas)
      ],
      stackBuild: (yearlyDatas) => [
        Positioned(
          top: 5.0,
          right: 5.0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: _createButtons(yearlyDatas)
          )
        )
      ],
      floatingActionButton: widget.account.status == AccountStatus.active && !widget.account.isMatured()
        ? FloatingActionButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddContribution(account: widget.account))),
          tooltip: 'Add new contribution',
          child: const StackedIcon(icon1: Icons.attach_money, icon2: Icons.add_box)
        )
        : null
    );
  }

  List<Widget> _createButtons(List<YearlyData> yearlyDatas) {
    List<Widget> widgets = [];
    
    if (widget.account.status == AccountStatus.active) {
      if (widget.account.isMatured()) {
        widgets.add(_createClaimButton(yearlyDatas));
      }
      widgets.add(_createEditButton());
    }
    widgets.add(_createDeleteButton());

    return widgets;
  }

  Widget _createClaimButton(List<YearlyData> yearlyDatas) {
    return SizedBox(
      width:  35.0,
      child: IconButton(
        tooltip: 'Claim account',
        icon: Icon(Icons.check, color: Colors.green.shade900),
        onPressed: () => DialogProvider.confirm(
          context: context,
          subject: 'Claim Confirmation',
          content: const Text('Are you want your account to be marked as claimed?'),
          defaultAction: () {
            if (yearlyDatas.last.monthly.where((contribution) => contribution.dividendStatus == DataStatus.forecasted).isNotEmpty) {
              Navigator.of(context).pop();
              DialogProvider.confirm(
                context: context,
                subject: 'Dividend Confirmation',
                content: const Column(children: [
                  Text('Dividend has not yet been declared.\n'),
                  Text('Previous year\'s rate', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('last declared dividend rate\n'),
                  Text('Current set rate', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('use this if the application has outdated declared years')
                ]),
                actions: [
                  CupertinoDialogAction(
                    onPressed: () => service.updateCustomDividend(
                      CustomDividend(
                        accountId: widget.account.id,
                        year: widget.account.maturityDate.year,
                        rate: yearlyDatas.elementAt(yearlyDatas.length - 2).rate
                      ),
                      callback: () => _claimAccount()
                    ),
                    child: const Text('Use Previous Rate')
                  ),
                  CupertinoDialogAction(
                    onPressed: () => _claimAccount(),
                    child: const Text('Use Current Rate')
                  )
                ]
              );
            } else {
              _claimAccount();
            }
          }
        )
      )
    );
  }

  void _claimAccount() {
    service.claim(
      widget.account.id,
      callback: () {
        notificationService.createAndNotify(
          context: context,
          notification: NotificationMessage(
            subject: 'Account Claimed',
            content: 'Your account (${widget.account.name}) has been successfully claimed.'
          )
        );
        Navigate.toAccountList(context, tabIndex: 1);
      }
    );
  }
  Widget _createEditButton() {
    return SizedBox(
      width: 25.0,
      child: IconButton(
        tooltip: 'Edit account',
        icon: Icon(Icons.edit, color: Colors.blue.shade900),
        onPressed: () => Navigate.toScreen(context, AddEditAccount(account: widget.account))
      )
    );
  }

  Widget _createDeleteButton() {
    return IconButton(
      tooltip: 'Delete account',
      icon: const Icon(Icons.delete),
      onPressed: () {
        String task;
        void Function() action;

        callback(String task, {required int tabIndex}) {
          notificationService.createAndNotify(
            context: context,
            notification: NotificationMessage(
              subject: 'Account ${task}d',
              content: 'Your account (${widget.account.name}) has been successfully ${task.toLowerCase()}d.'
            )
          );
          Navigate.toAccountList(context, tabIndex: 2);
        }

        if (widget.account.status == AccountStatus.inactive) {
          task = 'Purge';
          action = () =>
            service.purgeAccount(
              widget.account.id,
              callback: callback(task, tabIndex: 2)
            );
        } else {
          task = 'Delete';
          action = () =>
            service.deleteAccount(
              widget.account.id,
              callback: callback(task, tabIndex: widget.account.status == AccountStatus.active ? 0 : 1)
            );
        }

        DialogProvider.confirm(
          context: context,
          subject: '$task Confirmation',
          content: Text('Are you sure you want to $task this account?'),
          defaultAction: action
        );
      }
    );
  }

  TableCell _createHeader({required String label, Color? color, void Function()? onTap}) {
    return TableCell(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: FittedBox(
            child: GestureDetector(
              onTap: onTap,
              child: Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: color)),
            )
          )
        )
      )
    );
  }

  TableRow _createRateHeader(List<YearlyData> yearlyDatas) {
    return TableRow(children: [
      _createHeader(label: 'Rate'),
      ...yearlyDatas.map((yearly) {
        Color? color;
        void Function()? action;

        final forecasted = yearly.monthly.where((monthlyDividends) => monthlyDividends.dividendStatus == DataStatus.forecasted);
        if (forecasted.isNotEmpty) {
          color = Colors.grey.shade600;
          action = () {
            final controller = TextEditingController();
            controller.text = yearly.rate.toFormatted();

            DialogProvider.confirm(
              context: context,
              subject: 'Dividend Change',
              content: StandardTextField(
                label: 'New Rate For ${yearly.year}',
                icon: Icons.percent,
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [AmountInputFormatter()]
              ),
              defaultAction: () => service.updateCustomDividend(
                CustomDividend(
                  accountId: widget.account.id,
                  year: yearly.year,
                  rate: double.parse(controller.text)
                ),
                callback: () {
                  NotificationService().createAndNotify(
                    context: context,
                    notification: NotificationMessage(
                      subject: 'Custom Dividend Update',
                      content:
                        'Your account (${widget.account.name}) dividend rate for year ${yearly.year}'
                        ' has been set to ${double.parse(controller.text).toFormatted()}%.'
                    )
                  );

                  Navigate.toScreen(
                    context,
                    AccountView(account: widget.account),
                    callback: () => Navigate.toAccountList(context)
                  );
                }
              )
            );
          };
        }
        
        return _createHeader(
          label: '${yearly.rate.toFormatted()}%',
          color: color,
          onTap: action
        );
      })
    ]);
  }
  
  List<TableRow> _createMonthlyRow(List<YearlyData> yearlyDatas) {
    return List.generate(13, (month) =>
      _createMonthRow(month, yearlyDatas.map((yearly)
        => yearly.monthly.where((contribution)
          => contribution.month == month).single))
    );
  }
  
  TableRow _createMonthRow(int month, Iterable<MonthlyData> monthlyData) {
    action(int year) {
      if (month > 0) {
        Navigate.toScreen(context, ContributionsView(
          account: widget.account,
          year: year,
          month: month
        ));
      }
    }

    return TableRow(children: [
      _createHeader(label: month.toMonthString()),
      ...monthlyData.map((contribution) {
        if (contribution.contributionStatus == DataStatus.none) {
          return StandardCellData(
            child: Icon(Icons.lock, color: Colors.grey.shade600, size: 12)
          );
        } else if (contribution.amount == 0.00) {
          return const TableCell(child: Center(child: Text('-')));
        } else if (contribution.contributionStatus == DataStatus.forecasted) {
          return _createData(
            value: contribution.amount,
            color: Colors.grey.shade600,
            onTap: () => action(contribution.year)
          );
        }
        return _createData(
          value: contribution.amount,
          onTap: () => action(contribution.year)
        );
      })
    ]);
  }
  
  TableRow _createYearlyTotalRow(Iterable<YearlyData> yearlyDatas) {
    Color? color = Colors.green.shade900;
    return TableRow(children: [
      _createHeader(label: 'Total', color: color),
      ...yearlyDatas.map((yearly) {
        final amount = yearly.monthly.fold(0.00, (total, contribution) => total + contribution.amount);
        if (amount == 0.00) {
          return const TableCell(child: Center(child: Text('-')));
        } else {
          final forecasted = yearly.monthly.where((monthlyContribution) => monthlyContribution.contributionStatus == DataStatus.forecasted);
          if (forecasted.isNotEmpty) {
            color = Colors.grey.shade600;
          }
          return _createData(
            value: amount,
            color: color,
            fontWeight: FontWeight.w600
          );
        }
      })
    ]);
  }

  TableRow _createDividendsRow(Iterable<YearlyData> yearlyDatas) {
    Color? color = Colors.green.shade900;
    return TableRow(children: [
      _createHeader(label: 'Dividends', color: color),
      ...yearlyDatas.map((yearly) {
        final dividend = yearly.monthly.fold(0.00, (total, contribution) => total + contribution.dividend);
        if (dividend == 0.00) {
          return const TableCell(child: Center(child: Text('-')));
        } else {
          final forecasted = yearly.monthly.where((monthlyDividends) => monthlyDividends.dividendStatus == DataStatus.forecasted);
          if (forecasted.isNotEmpty) {
            color = Colors.grey.shade600;
          }
          return _createData(
            value: dividend,
            color: color,
            fontWeight: FontWeight.w600
          );
        }
      })
    ]);
  }

  TableCell _createData({required double value, Color? color, FontWeight? fontWeight, void Function()? onTap}) {
    return StandardCellData(
      child: FittedBox(
        child: GestureDetector(
          onTap: onTap,
          child: Text(
            value.toFormatted(),
            style: TextStyle(color: color, fontWeight: fontWeight))
        )
      )
    );
  }

  Widget _createTotals(List<YearlyData> yearlyDatas) {
    final contributions = service.calculateTotalContributions(yearlyDatas);
    final dividends = service.calculateTotalDividends(yearlyDatas);
    final total = contributions + dividends;
    final forecastedContributions = service.calculateTotalForecastedContributions(yearlyDatas);
    final forecastedDividends = service.calculateTotalForecastedDividends(yearlyDatas);
    final forecastedTotal = forecastedContributions + forecastedDividends;

    var widgets = [
      Divider(color: Colors.green.shade900),
      LabelValue(label: 'Accumulated Contributions', value: contributions.toString()),
      LabelValue(label: 'Accumulated Dividends', value: dividends.toString()),
      LabelValue(label: 'Accumulated Total Amount', value: total.toString())
    ];

    if (widget.account.targetAmount > 0) {
      final done = (total / widget.account.targetAmount) * 100;
      widgets.add(LabelValue(
        label: 'Target Amount',
        value: widget.account.targetAmount.toString(),
        appendOnAmount: ' (${done.toFormatted()}%)'
      ));
    }
    widgets.add(Divider(color: Colors.green.shade900));

    if (total != forecastedTotal) {
      widgets = [
        ...widgets,
        LabelValue(label: 'Forecasted Contributions', value: forecastedContributions.toString()),
        LabelValue(label: 'Forecasted Dividends', value: forecastedDividends.toString()),
        LabelValue(label: 'Forecasted Total Amount', value: forecastedTotal.toString()),
        Divider(color: Colors.green.shade900)
      ];
    }
    
    return Column(children: widgets);
  }
}

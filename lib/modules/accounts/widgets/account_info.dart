import 'package:flutter/material.dart';
import 'package:mp2_tracker/modules/accounts/dto/yearly_data.dart';
import 'package:mp2_tracker/modules/accounts/screens/account_view.dart';
import 'package:mp2_tracker/modules/accounts/entity/account.dart';
import 'package:mp2_tracker/modules/accounts/services/account_service.dart';
import 'package:mp2_tracker/shared/extensions/date_extension.dart';
import 'package:mp2_tracker/shared/extensions/double_extension.dart';
import 'package:mp2_tracker/shared/tools/navigate.dart';
import 'package:mp2_tracker/shared/widgets/card_3d.dart';
import 'package:mp2_tracker/shared/widgets/label_value.dart';
import 'package:mp2_tracker/shared/widgets/standard_future_builder.dart';

class AccountInfo extends StatefulWidget {
  const AccountInfo({
    super.key,
    required this.account
  });
  
  final Account account;

  @override
  State<StatefulWidget> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  final service = AccountService();

  @override
  Widget build(BuildContext context) {
    return StandardFutureBuilder(
      future: service.calculate(widget.account),
      widgetBuild: (yearlyDatas) => Card3D(
        content: [ ...createContent(widget.account, yearlyDatas) ],
        color: widget.account.isMatured() ? Colors.green : null,
        onTap: () => Navigate.toScreen(context, AccountView(account: widget.account)),
      )
    );
  }

  List<Widget> createContent(Account account, Iterable<YearlyData> yearlyDatas) {
    final contributions = service.calculateTotalContributions(yearlyDatas);
    final dividends = service.calculateTotalDividends(yearlyDatas);
    final total = contributions + dividends;

    List<Widget> widgets = [
      Row(children: [
        Icon(account.icon),
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Text(
            '${account.name} ${account.number == '' ? '' : '(${account.number})'}',
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600
            )
          )
        )
      ]),
      Text(
        '${account.startDate.toDefaultFormat()} - ${account.maturityDate.toDefaultFormat()}',
        style: const TextStyle(
          fontSize: 13.0,
          fontWeight: FontWeight.w600
        )
      ),
      LabelValue(label: 'Contributions', value: contributions.toString()),
      LabelValue(label: 'Dividends', value: dividends.toString()),
      LabelValue(label: 'Total Amount', value: (contributions + dividends).toString())
    ];

    if (account.targetAmount > 0) {
      final done = (total / account.targetAmount) * 100;
      widgets.add(LabelValue(
        label: 'Target Amount',
        value: account.targetAmount.toString(),
        appendOnAmount: ' (${done.toFormatted()}%)'
      ));
    }

    if (account.claimDate != null) {
      widgets.add(LabelValue(
        label: 'Claim Date',
        value: account.claimDate!.toDefaultFormat(),
        isAmount: false
      ));
    }

    if (account.deletedDate != null) {
      widgets.add(LabelValue(
        label: 'Deleted Date',
        value: account.deletedDate!.toDefaultFormat(),
        isAmount: false
      ));
    }

    return widgets;
  }
}

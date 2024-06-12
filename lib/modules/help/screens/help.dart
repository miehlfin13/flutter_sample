import 'package:flutter/material.dart';
import 'package:mp2_tracker/modules/help/screens/help_adding_account.dart';
import 'package:mp2_tracker/modules/help/screens/help_claiming_account.dart';
import 'package:mp2_tracker/modules/help/screens/help_custom_dividends.dart';
import 'package:mp2_tracker/modules/help/screens/help_date_contribution.dart';
import 'package:mp2_tracker/modules/help/screens/help_declared_dividends.dart';
import 'package:mp2_tracker/modules/help/screens/help_deleting_account.dart';
import 'package:mp2_tracker/modules/help/screens/help_deleting_contribution.dart';
import 'package:mp2_tracker/modules/help/screens/help_editing_account.dart';
import 'package:mp2_tracker/modules/help/screens/help_monthly_contribution.dart';
import 'package:mp2_tracker/modules/help/screens/help_periodic_forecast.dart';
import 'package:mp2_tracker/modules/help/screens/help_purging_account.dart';
import 'package:mp2_tracker/modules/help/screens/help_viewing_account.dart';
import 'package:mp2_tracker/modules/help/screens/help_viewing_contribution.dart';
import 'package:mp2_tracker/modules/help/screens/help_weekly_contribution.dart';
import 'package:mp2_tracker/modules/help/screens/help_yearly_contribution.dart';
import 'package:mp2_tracker/shared/tools/navigate.dart';
import 'package:mp2_tracker/shared/widgets/padded_column.dart';
import 'package:mp2_tracker/shared/widgets/templates/standard_template.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return StandardTemplate(
      title: 'Help',
      content: [
        Column(children: [
            Image.asset('assets/logo.png', height: 64.0, width: 64.0),
            const Text('Version: 0.1.0'),
        ]),
        PaddedColumn(
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _createHeader(label: 'Accounts'),
            _createLink(label: 'Adding Account', onTap: () => _navigate(context, const HelpAddingAccount())),
            _createLink(label: 'Viewing Account', onTap: () => _navigate(context, const HelpViewingAccount())),
            _createLink(label: 'Editing Account', onTap: () => _navigate(context, const HelpEditingAccount())),
            _createLink(label: 'Deleting Account', onTap: () => _navigate(context, const HelpDeletingAccount())),
            _createLink(label: 'Purging Account', onTap: () => _navigate(context, const HelpPurgingAccount())),
            _createLink(label: 'Claiming Account', onTap: () => _navigate(context, const HelpClaimmingAccount())),
            _createHeader(label: 'Contributions'),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Adding Contribution',
                style: TextStyle(fontSize: 18.0)
              )
            ),
            _createLink(label: '- Exact Date', onTap: () => _navigate(context, const HelpDateContribution())),
            _createLink(label: '- Weekly', onTap: () => _navigate(context, const HelpWeeklyContribution())),
            _createLink(label: '- Monthly', onTap: () => _navigate(context, const HelpMonthlyContribution())),
            _createLink(label: '- Yearly', onTap: () => _navigate(context, const HelpYearlyContribution())),
            _createLink(label: 'Viewing Contribution', onTap: () => _navigate(context, const HelpViewingContribution())),
            _createLink(label: 'Deleting Contribution', onTap: () => _navigate(context, const HelpDeletingContribution())),
            _createHeader(label: 'Dividend Rates'),
            _createLink(label: 'Declared', onTap: () => _navigate(context, const HelpDeclaredDividends())),
            _createLink(label: 'Custom', onTap: () => _navigate(context, const HelpCustomDividends())),
            _createHeader(label: 'Forecasts'),
            _createLink(label: 'Periodic Contribution', onTap: () => _navigate(context, const HelpPeriodicForecast()))
          ]
        )
      ]
    );
  }

  Text _createHeader({required String label}) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold
      )
    );
  }

  GestureDetector _createLink({required String label, required void Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.purple.shade900
          )
        )
      )
    );
  }

  void _navigate(BuildContext context, Widget screen) {
    Navigate.toScreen(context, screen);
  }
}

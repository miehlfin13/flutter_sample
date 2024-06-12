import 'package:flutter/material.dart';
import 'package:mp2_tracker/shared/constants/app.dart';
import 'package:mp2_tracker/shared/widgets/label_value.dart';
import 'package:mp2_tracker/shared/widgets/padded_column.dart';
import 'package:mp2_tracker/shared/widgets/templates/standard_template.dart';

class About extends  StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return StandardTemplate(
      title: 'About',
      content: [
        PaddedColumn(
          padding: const EdgeInsets.all(20),
          children: [
            Image.asset('assets/logo.png', height: 64.0, width: 64.0),
            Text('Version: ${App.version}'),
            const Text(
              '\n'
              'Welcome to MP2 Tracker, your personal tool to manage your Pag-IBIG MP2 savings!'
              ' Track your contributions, monitor dividend earnings, and forecast your savings growth with ease.'
              ' Stay on top of your financial goals and make the most out of your savings with MP2 Tracker!'
              '\n\n'
              'This tool only calculates up until the account maturity date.'
              ' The two year grace period which uses the regular savings dividend rate will not be calculated.'
              '\n\n'
              'We value your input! Help us improve MP2 Tracker by sending us your feedback and suggestions.'
              ' Feel free to send us a message.'
              '\n',
              textAlign: TextAlign.justify
            ),
            const LabelValue(
              label: 'Email',
              value: 'support.mp2tracker@synith.io',
              isAmount: false
            ),
            const LabelValue(
              label: 'Facebook',
              value: 'https://www.facebook.com/mp2tracker',
              isAmount: false
            ),
            const Text('\nThank you for your support!')
          ]
        )
      ]
    );
  }
}

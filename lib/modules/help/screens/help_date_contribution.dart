import 'package:flutter/material.dart';
import 'package:mp2_tracker/modules/help/widgets/help_template.dart';

class HelpDateContribution extends StatelessWidget {
  const HelpDateContribution({super.key});

  @override
  Widget build(BuildContext context) {
    return const HelpTemplate(
      title: 'Date Contribution',
      steps: [
        'Go to the account list screen',
        'Go to the active tab',
        'Press the account card',
        'Press the add icon on the bottom-right of the screen',
        'Select day as contribution type',
        'Fill-up the necessary details',
        'Press the save icon on the bottom-right of the screen',
        'Confirm if the details are correct, then press OK'
      ]
    );
  }
}

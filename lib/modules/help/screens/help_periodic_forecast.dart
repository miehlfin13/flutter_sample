import 'package:flutter/material.dart';
import 'package:mp2_tracker/modules/help/widgets/help_template.dart';

class HelpPeriodicForecast extends StatelessWidget {
  const HelpPeriodicForecast({super.key});

  @override
  Widget build(BuildContext context) {
    return const HelpTemplate(
      title: 'Periodic Forecast',
      steps: [
        'Go to the account list screen',
        'Press the menu icon on the top-left of the screen',
        'Select forecast',
        'Fill-up the necessary details',
        'Press the save icon on the bottom-right of the screen',
        'Confirm if the details are correct, then press OK'
      ]
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mp2_tracker/modules/help/widgets/help_template.dart';

class HelpCustomDividends extends StatelessWidget {
  const HelpCustomDividends({super.key});

  @override
  Widget build(BuildContext context) {
    return const HelpTemplate(
      title: 'Custom Dividends',
      steps: [
        'Go to the account list screen',
        'Press the account card',
        'Press any rate that has not been declared',
        'Modify the necessary details',
        'Confirm by pressing OK'
      ]
    );
  }
}

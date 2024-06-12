import 'package:flutter/material.dart';
import 'package:mp2_tracker/modules/help/widgets/help_template.dart';

class HelpAddingAccount extends StatelessWidget {
  const HelpAddingAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return const HelpTemplate(
      title: 'Adding New Account',
      steps: [
        'Go to the account list screen',
        'Press the add icon on the bottom-right of the screen',
        'Fill-up the necessary details',
        'Press the save icon on the bottom-right of the screen',
        'Confirm if the details are correct, then press OK'
      ]
    );
  }
}

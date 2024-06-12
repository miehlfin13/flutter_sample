import 'package:flutter/material.dart';
import 'package:mp2_tracker/modules/help/widgets/help_template.dart';

class HelpEditingAccount extends StatelessWidget {
  const HelpEditingAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return const HelpTemplate(
      title: 'Editing Account',
      steps: [
        'Go to the account list screen',
        'Press the account card',
        'Press the edit icon on the top-right of the screen',
        'Modify the necessary details',
        'Press the save icon on the bottom-right of the screen',
        'Confirm if the details are correct, then press OK'
      ]
    );
  }
}

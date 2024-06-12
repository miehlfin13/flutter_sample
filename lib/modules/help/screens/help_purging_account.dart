import 'package:flutter/material.dart';
import 'package:mp2_tracker/modules/help/widgets/help_template.dart';

class HelpPurgingAccount extends StatelessWidget {
  const HelpPurgingAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return const HelpTemplate(
      title: 'Purging Account',
      steps: [
        'Go to the account list screen',
        'Go to the deleted tab',
        'Press the account card',
        'Press the purge icon on the top-right of the screen',
        'Confirm purge process by pressing OK'
      ]
    );
  }
}

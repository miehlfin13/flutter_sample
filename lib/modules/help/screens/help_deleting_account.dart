import 'package:flutter/material.dart';
import 'package:mp2_tracker/modules/help/widgets/help_template.dart';

class HelpDeletingAccount extends StatelessWidget {
  const HelpDeletingAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return const HelpTemplate(
      title: 'Deleting Account',
      steps: [
        'Go to the account list screen',
        'Press the account card',
        'Press the delete icon on the top-right of the screen',
        'Confirm delete process by pressing OK'
      ]
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mp2_tracker/modules/help/widgets/help_template.dart';

class HelpViewingAccount extends StatelessWidget {
  const HelpViewingAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return const HelpTemplate(
      title: 'Viewing Account',
      steps: [
        'Go to the account list screen',
        'Press the account card'
      ]
    );
  }
}

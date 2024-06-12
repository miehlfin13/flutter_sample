import 'package:flutter/material.dart';
import 'package:mp2_tracker/modules/help/widgets/help_template.dart';

class HelpClaimmingAccount extends StatelessWidget {
  const HelpClaimmingAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return const HelpTemplate(
      title: 'Claiming Account',
      steps: [
        'Go to the account list screen',
        'Go to the active tab',
        'Press the account card that is colored green',
        'Press the claim icon on the top-right of the screen',
        'Confirm the claim process by pressing OK'
        ' \n\n'
        'Note: Additional confirmation will show if the maturity year dividend rate has not been declared yet on the app'
      ]
    );
  }
}

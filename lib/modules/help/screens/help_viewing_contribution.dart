import 'package:flutter/material.dart';
import 'package:mp2_tracker/modules/help/widgets/help_template.dart';

class HelpViewingContribution extends StatelessWidget {
  const HelpViewingContribution({super.key});

  @override
  Widget build(BuildContext context) {
    return const HelpTemplate(
      title: 'Viewing Contribution',
      steps: [
        'Go to the account list screen',
        'Press the account card',
        'Press any month contribution on the grid'
      ]
    );
  }
}

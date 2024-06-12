import 'package:flutter/material.dart';
import 'package:mp2_tracker/modules/help/widgets/help_template.dart';

class HelpDeclaredDividends extends StatelessWidget {
  const HelpDeclaredDividends({super.key});

  @override
  Widget build(BuildContext context) {
    return const HelpTemplate(
      title: 'Declared Dividends',
      steps: [
        'Go to the account list screen',
        'Press the menu icon on the top-left of the screen',
        'Select declared dividends'
      ]
    );
  }
}

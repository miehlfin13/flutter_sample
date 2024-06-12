import 'package:flutter/material.dart';
import 'package:mp2_tracker/modules/help/widgets/help_template.dart';

class HelpDeletingContribution extends StatelessWidget {
  const HelpDeletingContribution({super.key});

  @override
  Widget build(BuildContext context) {
    return const HelpTemplate(
      title: 'Deleting Contribution',
      steps: [
        'Go to the account list screen',
        'Press the account card',
        'Press any month contribution on the grid',
        'Press the delete icon beside the contribution you want to delete',
        'Confirm delete process by pressing OK'
      ]
    );
  }
}

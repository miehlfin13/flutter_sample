import 'package:flutter/material.dart';
import 'package:mp2_tracker/shared/widgets/card_3d.dart';
import 'package:mp2_tracker/shared/widgets/templates/standard_template.dart';

class HelpTemplate extends StatelessWidget {
  const HelpTemplate({
    super.key,
    required this.title,
    required this.steps
  });

  final String title;
  final List<String> steps;
  
  @override
  Widget build(BuildContext context) {
    return StandardTemplate(
      title: title,
      hasCard: false,
      content: [
        ...steps.asMap().entries.map((entry) {
          int index = entry.key;
          String step = entry.value;
          return Card3D(content: [Text('${index + 1}. $step')]);
        })
      ]
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mp2_tracker/shared/widgets/card_3d.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap
  });

  final String label;
  final IconData icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card3D(
      onTap: onTap,
      content: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Icon(icon)
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 24.0)
            )
          ]
        )
      ]
    );
  }
}

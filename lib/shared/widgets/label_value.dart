import 'package:flutter/material.dart';
import 'package:mp2_tracker/shared/extensions/double_extension.dart';

class LabelValue extends StatelessWidget {
  const LabelValue({
    super.key,
    required this.label,
    required this.value,
    this.isAmount = true,
    this.appendOnAmount = ''
  });

  final String label;
  final String value;
  final bool isAmount;
  final String appendOnAmount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w400
          )
        ),
        Text(
          isAmount
            ? '₱${double.parse(value).toFormatted()}$appendOnAmount'
            : value,
          style: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w600
          )
        )
      ]
    );
  }
}

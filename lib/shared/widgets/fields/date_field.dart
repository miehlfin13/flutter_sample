import 'package:flutter/material.dart';
import 'package:mp2_tracker/shared/tools/date_selector.dart';
import 'package:mp2_tracker/shared/widgets/fields/standard_text_field.dart';

class DateField extends StandardTextField {
  DateField({
    super.key,
    required BuildContext context,
    required super.label,
    super.icon,
    required super.controller,
    DateTime? firstDate,
    DateTime? lastDate,
    required void Function(DateTime value) onSelect,
    required void Function() onCancel
  })
  : super(
    readOnly: true,
    onTap: () => DateSelector.show(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      onSelect: onSelect,
      onCancel: onCancel
    )
  );
}

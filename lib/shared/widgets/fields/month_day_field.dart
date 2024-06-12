import 'package:flutter/material.dart';
import 'package:mp2_tracker/shared/widgets/fields/standard_dropdown_field.dart';

class MonthDayField extends StandardDropDownField {
  MonthDayField({
    super.key, 
    required super.onChanged
  })
  : super(
    label: 'Day of Month',
    icon: Icons.calendar_month,
    items: List.generate(31, (index) {
      return DropdownMenuItem(
        value: index + 1,
        child: Text('${index + 1}'),
      );
    })
  );
}

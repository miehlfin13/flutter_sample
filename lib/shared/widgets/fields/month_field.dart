import 'package:flutter/material.dart';
import 'package:mp2_tracker/shared/extensions/int_extension.dart';
import 'package:mp2_tracker/shared/widgets/fields/standard_dropdown_field.dart';

class MonthField extends StandardDropDownField {
  MonthField({
    super.key,
    required super.onChanged
  })
  : super(
    label: 'Month',
    icon: Icons.calendar_today,
    items: List.generate(12, (index) {
      return DropdownMenuItem(
        value: index + 1,
        child: Text((index + 1).toFullMonthString()),
      );
    })
  );
}

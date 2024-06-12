import 'package:flutter/material.dart';
import 'package:mp2_tracker/shared/extensions/int_extension.dart';
import 'package:mp2_tracker/shared/widgets/fields/standard_dropdown_field.dart';

class WeekDayField extends StandardDropDownField {
  WeekDayField({
    super.key,
    required super.onChanged
  })
  : super(
    label: 'Day of Week',
    icon: Icons.calendar_view_week,
    items: List.generate(7, (index) {
      return DropdownMenuItem(
        value: index,
        child: Text(index.toFullWeekString()),
      );
    })
  );
}

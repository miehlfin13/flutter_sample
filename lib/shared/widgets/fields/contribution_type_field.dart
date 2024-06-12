import 'package:flutter/material.dart';
import 'package:mp2_tracker/modules/accounts/enums/contribution_type.dart';
import 'package:mp2_tracker/shared/widgets/fields/standard_dropdown_field.dart';

class ContributionTypeField extends StandardDropDownField {
  ContributionTypeField({
    super.key,
    required super.onChanged,
    ContributionType initialValue = ContributionType.day,
    bool isDayIncluded = true
  })
  : super(
    label: 'Contribution Type',
    icon: Icons.payments,
    value: initialValue,
    items: [
      if (isDayIncluded) const DropdownMenuItem(value: ContributionType.day, child: Text('Day')),
      const DropdownMenuItem(value: ContributionType.weekly, child: Text('Weekly')),
      const DropdownMenuItem(value: ContributionType.monthly, child: Text('Monthly')),
      const DropdownMenuItem(value: ContributionType.yearly, child: Text('Yearly'))
    ]
  );
}

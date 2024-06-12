import 'package:flutter/material.dart';
import 'package:mp2_tracker/shared/extensions/icon_data_extension.dart';
import 'package:mp2_tracker/shared/tools/icon_provider.dart';
import 'package:mp2_tracker/shared/widgets/fields/standard_dropdown_field.dart';

class IconField extends StandardDropDownField {
  IconField({
    super.key,
    super.value,
    required super.onChanged
  })
  : super(
    label: 'Icon',
    items: [
      ...IconProvider.getAll().map((icon) => DropdownMenuItem(
        value: icon.codePoint,
        child: Row(
          children: [
            Icon(icon),
            Text('   ${icon.toLabelString()}')
          ],
        )
      ))
    ]
  );
}

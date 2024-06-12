import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mp2_tracker/shared/widgets/fields/standard_text_field.dart';

class NumberField extends StandardTextField {
  NumberField({
    super.key,
    required super.label,
    required super.controller,
    int maxLength = 12
  })
  : super(
    icon: Icons.onetwothree,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(maxLength)
    ]
  );
}

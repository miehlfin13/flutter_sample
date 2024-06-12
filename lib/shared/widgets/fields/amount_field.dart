import 'package:flutter/material.dart';
import 'package:mp2_tracker/shared/tools/amount_input_formatter.dart';
import 'package:mp2_tracker/shared/widgets/fields/standard_text_field.dart';

class AmountField extends StandardTextField {
  AmountField({
    super.key,
    super.label = 'Amount',
    super.icon = Icons.attach_money,
    required super.controller
  })
  : super(
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    inputFormatters: [AmountInputFormatter()]
  );
}

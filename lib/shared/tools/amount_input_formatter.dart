import 'package:flutter/services.dart';

class AmountInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Allow only digits, an optional decimal point, and up to 2 decimal places
    if (RegExp(r'^\d+\.?\d{0,2}$').hasMatch(newValue.text)) {
      const limit = 10000000.0;
      double value = double.tryParse(newValue.text) ?? 0.0;
      
      if (value > limit) {
        value = limit;
        String newText = value.toStringAsFixed(2);
        return TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
      }
      return newValue;
    }
    return oldValue;
  }
}

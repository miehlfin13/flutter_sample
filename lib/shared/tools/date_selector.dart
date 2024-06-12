import 'package:flutter/material.dart';

class DateSelector {
  static Future<void> show({
    required BuildContext context,
    DateTime? firstDate,
    DateTime? lastDate,
    required void Function(DateTime value) onSelect,
    required void Function() onCancel
  }) async {
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: firstDate ?? DateTime(2011),
      lastDate: lastDate ?? DateTime(2200)
    );

    if (selected != null) {
      onSelect(selected);
    } else {
      onCancel;
    }
  }
}
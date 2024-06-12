import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StandardCellData extends TableCell {
  StandardCellData({
    super.key, required Widget child
  })
  : super(
    verticalAlignment: TableCellVerticalAlignment.middle,
    child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
        child: child
      ),
    )
  );
}
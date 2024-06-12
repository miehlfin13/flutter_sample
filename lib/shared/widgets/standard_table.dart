import 'package:flutter/material.dart';

class StandardTable extends StatelessWidget {
  const StandardTable({
    super.key,
    required this.headers,
    required this.data
    });

  final List<String> headers;
  final List<List<Widget>> data;

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(width: 2, borderRadius: BorderRadius.circular(10)),
      children: [
        TableRow(children: headers.map((header)=> _createRowHeader(header)).toList()),
        ...data.map((rowsData) => TableRow(children: rowsData.map((rowData) => _createRowValue(rowData)).toList()))
      ]
    );
  }

  TableCell _createRowHeader(String label) {
    return TableCell(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold
            )
          )
        )
      )
    );
  }

  TableCell _createRowValue(Widget value) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: FittedBox(
            child: value
          )
        )
      )
    );
  }
}

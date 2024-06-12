
import 'package:flutter/material.dart';
import 'package:mp2_tracker/modules/dividends/services/dividend_service.dart';
import 'package:mp2_tracker/shared/extensions/double_extension.dart';
import 'package:mp2_tracker/shared/widgets/standard_table.dart';
import 'package:mp2_tracker/shared/widgets/templates/future_template.dart';

class DeclaredDividendList extends StatefulWidget {
  const DeclaredDividendList({super.key});

  @override
  State<StatefulWidget> createState() => _DeclaredDividendListState();
}

class _DeclaredDividendListState extends State<DeclaredDividendList> {
  @override
  Widget build(BuildContext context) {
    return FutureTemplate(
      title: 'Declared Dividends',
      future: DividendService().fetchAll(),
      widgetBuild:(dividends) => [
        StandardTable(
          headers: const [
            'Year',
            'Rate'
          ],
          data: dividends.map((dividend) => [
            Text(dividend.year.toString()),
            Text('${dividend.rate.toFormatted()}%')
          ]).toList()
        )
      ]
    );
  }
}

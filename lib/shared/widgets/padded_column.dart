import 'package:flutter/material.dart';

class PaddedColumn extends StatelessWidget {
  const PaddedColumn({
    super.key,
    required this.padding,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center
  });

  final EdgeInsetsGeometry padding;
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: children
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mp2_tracker/shared/widgets/padded_column.dart';

class Card3D<T> extends StatefulWidget {
  const Card3D({
    super.key,
    required this.content,
    this.stack,
    this.color,
    this.onTap
  });

  final List<Widget> content;
  final List<Widget>? stack;
  final Color? color;
  final void Function()? onTap;

  @override
  State<StatefulWidget> createState() => _Card3DState<T>();
}

class _Card3DState<T> extends State<Card3D<T>> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
        child: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(38, 57, 77, 1),
                offset: Offset(0, 20),
                blurRadius: 30,
                spreadRadius: -10,
              )
            ]
          ),
          child: Stack(children: [
            Card(
              color: widget.color ?? Colors.blue.shade200,
              child: PaddedColumn(
                padding: const EdgeInsets.all(10.0),
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: widget.content,
              )
            ),
          ...widget.stack ?? []
          ])
        )
      )
    );
  }
}
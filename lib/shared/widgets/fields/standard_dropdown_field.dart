import 'package:flutter/material.dart';

class StandardDropDownField extends StatefulWidget {
  const StandardDropDownField({
    super.key,
    required this.label,
    this.icon = Icons.abc,
    required this.items,
    this.value,
    this.onChanged
  });

  final String label;
  final IconData icon;
  final List<DropdownMenuItem> items;
  final dynamic value;
  final void Function(dynamic)? onChanged;
  
  @override
  State<StatefulWidget> createState() => _StandardDropDownFieldState();
}

class _StandardDropDownFieldState extends State<StandardDropDownField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: widget.label,
          prefixIcon: Icon(widget.icon),
        ),
        items: widget.items,
        value: widget.value,
        onChanged: widget.onChanged
      ),
    );
  }
}

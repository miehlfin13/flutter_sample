import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StandardTextField extends StatefulWidget {
  const StandardTextField({
      super.key,
      required this.label,
      this.icon = Icons.abc,
      this.controller,
      this.inputFormatters,
      this.keyboardType,
      this.readOnly = false,
      this.obscureText = false,
      this.onTap
    });

  final String label;
  final IconData icon;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final bool readOnly;
  final bool obscureText;
  final void Function()? onTap;

  @override
  State<StatefulWidget> createState() => _StandardTextFieldState();
}

class _StandardTextFieldState extends State<StandardTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        controller: widget.controller,
        inputFormatters: widget.inputFormatters,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: widget.label,
          prefixIcon: Icon(widget.icon),
        ),
        readOnly: widget.readOnly,
        obscureText: widget.obscureText,
        onTap: widget.onTap,
      )
    );
  }
}

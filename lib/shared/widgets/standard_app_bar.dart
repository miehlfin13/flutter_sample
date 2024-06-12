import 'package:flutter/material.dart';

class StandardAppBar extends AppBar {
  StandardAppBar({
    super.key,
    required String title,
    super.bottom
  })
  : super(
    title: Text(
      title,
      style: const TextStyle(
        color: Colors.white
      )
    ),
    backgroundColor: Colors.blue.shade800
  );
}

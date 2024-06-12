import 'package:flutter/material.dart';

class StandardFutureBuilder<T> extends FutureBuilder<T> {
  StandardFutureBuilder({
    super.key,
    required super.future,
    required Widget Function(T data) widgetBuild
  })
  : super(
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return widgetBuild(snapshot.data as T);
      }
    }
  );
}

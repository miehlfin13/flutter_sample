import 'package:flutter/widgets.dart';

class LoadingAd extends StatelessWidget {
  const LoadingAd({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 60.0,
      child: Center(
        child: Text('No ads to load')
      )
    );
  }
}

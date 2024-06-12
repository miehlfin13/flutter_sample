import 'package:flutter/material.dart';

class StackedIcon extends StatelessWidget {
  const StackedIcon({
    super.key,
    required this.icon1,
    required this.icon2
  });

  final IconData icon1;
  final IconData icon2;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ClipPath(
        clipper: BottomRightClipper(),
        child: Icon(icon1),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: Icon(icon2, size: 12),
      )
    ]);
  }
}

class BottomRightClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width / 2, size.height / 2);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
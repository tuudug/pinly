import 'package:flutter/widgets.dart';

class Circle extends StatelessWidget {
  final Color color;
  final double radius;

  const Circle({super.key, required this.color, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

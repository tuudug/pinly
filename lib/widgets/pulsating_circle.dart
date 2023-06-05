import 'package:flutter/material.dart';

class PulsatingCircle extends StatefulWidget {
  final double size;
  final Color color;
  final Duration duration;

  const PulsatingCircle({
    Key? key,
    required this.size,
    required this.color,
    this.duration = const Duration(milliseconds: 1000),
  }) : super(key: key);

  @override
  _PulsatingCircleState createState() => _PulsatingCircleState();
}

class _PulsatingCircleState extends State<PulsatingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ),
      ),
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color
                .withOpacity(0.1 + 0.5 * _animationController.value),
          ),
        );
      },
    );
  }
}

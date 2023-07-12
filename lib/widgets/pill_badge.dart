import 'package:flutter/material.dart';

class PillBadge extends StatelessWidget {
  final Color badgeColor;
  final Color textColor;
  final String text;

  const PillBadge(
      {super.key,
      required this.badgeColor,
      required this.textColor,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class NoEntries extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? buttonText;
  final void Function()? buttonAction;

  const NoEntries({
    required this.icon,
    required this.text,
    this.buttonText,
    this.buttonAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon, // Replace this with your desired icon
            size: 72.0,
            color: Colors.grey,
          ),
          SizedBox(height: 16.0),
          Text(
            text,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          (buttonText != null && buttonAction != null)
              ? TextButton(
                  onPressed: buttonAction,
                  child: Text(
                    buttonText ?? "",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ))
              : Container()
        ],
      ),
    );
  }
}

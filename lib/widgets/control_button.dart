import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const ControlButton({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: color),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
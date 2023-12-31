import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;

  const ControlButton({
    super.key,
    this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) => ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      );
}

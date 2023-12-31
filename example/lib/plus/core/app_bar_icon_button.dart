import 'package:flutter/material.dart';

class AppBarIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const AppBarIconButton({super.key, this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) => IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
      );
}

import 'package:flutter/material.dart';

class EditorControls extends StatelessWidget {
  final List<Widget> controls;

  const EditorControls({super.key, required this.controls});

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: controls,
          ),
        ),
      );
}

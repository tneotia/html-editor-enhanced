import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:html_editor_enhanced_fork_latex/utils/custom_math_field_controller.dart';
import 'package:math_keyboard/math_keyboard.dart';

class MathKeyboardDialog extends StatelessWidget {
  MathKeyboardDialog({required this.controller, this.mathField}) {
    if (mathField != null && mathField!.controller != null) {
      log('',
          name: 'Warning',
          error:
              'do not set the math field controller as it will get ignored\n');
    }
  }

  final CustomMathFieldEditingController controller;
  final MathField? mathField;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: MathField(
                focusNode: mathField?.focusNode,
                autofocus: mathField?.autofocus ?? true,
                controller: controller,
                keyboardType:
                    mathField?.keyboardType ?? MathKeyboardType.expression,
                variables:
                    mathField?.variables ?? ['x', 'y', 'z', 'A', 'B', 'C'],
                decoration: mathField?.decoration ??
                    InputDecoration(
                      suffix: MouseRegion(
                        cursor: MaterialStateMouseCursor.clickable,
                        child: GestureDetector(
                          onTap: controller.clear,
                          child: const Icon(
                            Icons.cleaning_services_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                onChanged: mathField?.onChanged ?? controller.setTexString,
                onSubmitted: mathField?.onSubmitted,
                opensKeyboard: mathField?.opensKeyboard ?? true,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, '');
                    print(controller.texStringAsFun);
                  },
                  child: const Text('Close'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, controller.texStringAsFun);
                    print(controller.texStringAsFun);
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

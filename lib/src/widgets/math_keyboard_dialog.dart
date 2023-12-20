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
    var tex = '';
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: MathField(
                focusNode: mathField?.focusNode,
                autofocus: mathField?.autofocus ?? true,
                controller: controller,
                variables:
                    mathField?.variables ?? ['x', 'y', 'z', 'A', 'B', 'C'],
                decoration: mathField?.decoration ??
                    InputDecoration(
                      suffix: MouseRegion(
                        cursor: MaterialStateMouseCursor.clickable,
                        child: GestureDetector(
                          onTap: controller.clear,
                          child: const Icon(
                            Icons.highlight_remove_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                onChanged: mathField?.onChanged ??
                    (str) {
                      tex = str;
                    },
                onSubmitted: mathField?.onSubmitted,
                opensKeyboard: mathField?.opensKeyboard ?? true,
              ),
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () {
                Navigator.pop(context, '');
                print(texStringAsFun(tex));
              },
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, controller.texStringAsFun);
                print(texStringAsFun(tex));
              },
              child: const Text('save'),
            ),
          ],
        ),
      ),
    );
  }

  String texStringAsFun(String str) => '\\($str\\)';
}

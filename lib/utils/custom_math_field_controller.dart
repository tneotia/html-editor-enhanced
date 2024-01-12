import 'package:flutter/material.dart';
import 'package:math_keyboard/math_keyboard.dart';

class CustomMathFieldEditingController extends MathFieldEditingController {
  /// Constructs a [MathKeyboardViewModel].
  CustomMathFieldEditingController() {
    currentNode = root;
    currentNode.setCursor();
  }

  String texString = '';

  void setTexString(String str) {
    texString = str;
  }

  String get texStringAsFun => '\\($texString\\)';

  @override
  String currentEditingValue({bool placeholderWhenEmpty = true}) {
    currentNode.removeCursor();
    // Store the expression as a TeX string.
    final expression = root.buildTeXString(
      // By passing null as the cursor color here, we are asserting
      // that the cursor is not part of the tree in a way.
      cursorColor: Colors.transparent,
      placeholderWhenEmpty: placeholderWhenEmpty,
    );
    currentNode.setCursor();
    final colorString =
        '#${(Colors.transparent.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
    var text = '\\textcolor{$colorString}{\\cursor}';
    return expression.replaceAll(text, '');
  }
}

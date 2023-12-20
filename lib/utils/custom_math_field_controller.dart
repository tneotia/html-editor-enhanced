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
}

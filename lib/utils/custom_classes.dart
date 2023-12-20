// import 'dart:ui';
//
// import 'package:flutter/foundation.dart';
// import 'package:math_keyboard/src/foundation/node.dart' as mk;
//
// /// Block representing a node of TeX.
// class TeXNode {
//   /// Constructs a [TeXNode].
//   TeXNode(this.parent);
//
//   /// The parent of the node.
//   TeXFunction? parent;
//
//   /// The courser position in this node.
//   int courserPosition = 0;
//
//   /// A block can have one or more child blocks.
//   final List<TeX> children = [];
//
//   /// Sets the courser to the actual position.
//   void setCursor() {
//     children.insert(courserPosition, const Cursor());
//   }
//
//   /// Removes the courser.
//   void removeCursor() {
//     children.removeAt(courserPosition);
//   }
//
//   /// Returns whether the last child node is the cursor.
//   ///
//   /// This does *not* traverse the children recursively as that might not be
//   /// a guarantee for visually being all the way on the right with the cursor.
//   /// Imagine a `\frac` node with a horizontally long string in the nominator:
//   /// now, when the cursor is at the end, it is not visually on the right of the
//   /// node as the denominator might not even be visible when scrolling to the
//   /// right.
//   bool cursorAtTheEnd() {
//     if (children.isEmpty) return false;
//     if (children.last is Cursor) return true;
//
//     return false;
//   }
//
//   /// Shift courser to the left.
//   NavigationState shiftCursorLeft() {
//     if (courserPosition == 0) {
//       return NavigationState.end;
//     }
//     removeCursor();
//     courserPosition--;
//     if (children[courserPosition] is TeXFunction) {
//       return NavigationState.func;
//     }
//     setCursor();
//     return NavigationState.success;
//   }
//
//   /// Shift courser to the right.
//   NavigationState shiftCursorRight() {
//     if (courserPosition == children.length - 1) {
//       return NavigationState.end;
//     }
//     removeCursor();
//     courserPosition++;
//     if (children[courserPosition - 1] is TeXFunction) {
//       return NavigationState.func;
//     }
//     setCursor();
//     return NavigationState.success;
//   }
//
//   /// Adds a new node.
//   void addTeX(TeX teX) {
//     children.insert(courserPosition, teX);
//     courserPosition++;
//   }
//
//   /// Removes the last node.
//   NavigationState remove() {
//     if (courserPosition == 0) {
//       return NavigationState.end;
//     }
//     removeCursor();
//     courserPosition--;
//     if (children[courserPosition] is TeXFunction) {
//       return NavigationState.func;
//     }
//     children.removeAt(courserPosition);
//     setCursor();
//     return NavigationState.success;
//   }
//
//   /// Builds the TeX representation of this node.
//   ///
//   /// This includes the representation of the children of the node.
//   ///
//   /// Returns the TeX expression as a [String].
//   static String buildTeXStringFromMathKeyboard({
//     Color? cursorColor,
//     bool placeholderWhenEmpty = true,
//     required mk.TeXNode root,
//   }) {
//     if (root.children.isEmpty) {
//       return placeholderWhenEmpty ? '\\Box' : '';
//     }
//     final buffer = StringBuffer();
//     for (final tex in root.children) {
//       buffer.write(tex.buildString(cursorColor: cursorColor));
//     }
//     return buffer.toString();
//   }
//
//   String buildTeXString({
//     Color? cursorColor,
//     bool placeholderWhenEmpty = true,
//   }) {
//     if (children.isEmpty) {
//       return placeholderWhenEmpty ? '\\Box' : '';
//     }
//     final buffer = StringBuffer();
//     for (final tex in children) {
//       buffer.write(tex.buildString(cursorColor: cursorColor));
//     }
//     return buffer.toString();
//   }
// }
//
// /// Class holding a TeX function.
// class TeXFunction extends TeX {
//   /// Constructs a [TeXFunction].
//   ///
//   /// [argNodes] can be passed directly if the nodes are already known. In that
//   /// case, the [TeXNode.parent] is set in the constructor body. If [argNodes]
//   /// is passed empty (default), empty [TeXNode]s will be inserted for each
//   /// arg.
//   TeXFunction(String expression, this.parent, this.args,
//       [List<TeXNode>? argNodes])
//       : assert(args.isNotEmpty, 'A function needs at least one argument.'),
//         assert(argNodes == null || argNodes.length == args.length),
//         argNodes = argNodes ?? List.empty(growable: true),
//         super(expression) {
//     if (this.argNodes.isEmpty) {
//       for (var i = 0; i < args.length; i++) {
//         this.argNodes.add(TeXNode(this));
//       }
//     } else {
//       for (final node in this.argNodes) {
//         node.parent = this;
//       }
//     }
//   }
//
//   /// The functions parent node.
//   TeXNode parent;
//
//   /// The delimiters of the arguments.
//   final List<TeXArg> args;
//
//   /// The arguments to this function.
//   final List<TeXNode> argNodes;
//
//   /// Returns the opening character for a function argument.
//   String openingChar(TeXArg type) {
//     switch (type) {
//       case TeXArg.braces:
//         return '{';
//       case TeXArg.brackets:
//         return '[';
//       default:
//         return '(';
//     }
//   }
//
//   /// Returns the closing character for a function argument.
//   String closingChar(TeXArg type) {
//     switch (type) {
//       case TeXArg.braces:
//         return '}';
//       case TeXArg.brackets:
//         return ']';
//       default:
//         return ')';
//     }
//   }
//
//   @override
//   String buildString({Color? cursorColor}) {
//     final buffer = StringBuffer(expression);
//     for (var i = 0; i < args.length; i++) {
//       buffer.write(openingChar(args[i]));
//       buffer.write(argNodes[i].buildTeXString(
//         cursorColor: cursorColor,
//       ));
//       buffer.write(closingChar(args[i]));
//     }
//     return buffer.toString();
//   }
// }
//
// /// Class holding a single TeX expression.
// class TeXLeaf extends TeX {
//   /// Constructs a [TeXLeaf].
//   const TeXLeaf(String expression) : super(expression);
//
//   @override
//   String buildString({Color? cursorColor}) {
//     return expression;
//   }
// }
//
// /// Class holding TeX.
// abstract class TeX {
//   /// Constructs a [TeX].
//   const TeX(this.expression);
//
//   /// The expression of this TeX
//   final String expression;
//
//   /// Builds the string representation of this TeX expression.
//   String buildString({required Color? cursorColor});
// }
//
// /// Class describing the cursor as a TeX expression.
// class Cursor extends TeX {
//   /// Creates a TeX [Cursor].
//   const Cursor() : super('');
//
//   @override
//   String buildString({required Color? cursorColor}) {
//     if (cursorColor == null) {
//       return '';
//     }
//     final colorString =
//         '#${(cursorColor.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
//     return '\\textcolor{$colorString}{\\cursor}';
//   }
// }
//
// /// The state of a node when trying to navigate back- or forward.
// enum NavigationState {
//   /// The upcoming tex expression in navigation direction is a function.
//   func,
//
//   /// The current courser position is already at the end.
//   end,
//
//   /// Navigating was successful.
//   success,
// }
//
// /// How the argument is marked.
// enum TeXArg {
//   /// { }
//   ///
//   /// In most of the cases, braces will be used. (E.g arguments of fractions).
//   braces,
//
//   /// [ ]
//   ///
//   /// Brackets are only used for the nth root at the moment.
//   brackets,
//
//   /// ()
//   ///
//   /// Parentheses are used for base n logarithm right now, but could be used
//   /// for functions like sin, cos, tan, etc. as well, so the user doesn't have
//   /// to close the parentheses manually.
//   parentheses,
// }

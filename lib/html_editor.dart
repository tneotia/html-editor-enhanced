library html_editor;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html_editor_enhanced/html_editor_widget.dart';

/// Global variable used to get the [InAppWebViewController] of the Html editor
InAppWebViewController controller;

/// Global variable used to get the text from the Html editor
String text = "";

class HtmlEditor extends StatelessWidget with WidgetsBindingObserver {
  HtmlEditor({
    Key key,
    this.initialText,
    this.height = 380,
    this.decoration,
    this.useBottomSheet = true,
    this.imageWidth = 100,
    this.showBottomToolbar = true,
    this.hint
  }) :  assert(imageWidth > 0 && imageWidth <= 100),
        super(key: key);

  /// The initial text that is be supplied to the Html editor.
  final String initialText;

  /// Sets the height of the Html editor. If you decide to show the bottom toolbar,
  /// this height will be inclusive of the space the toolbar takes up.
  ///
  /// The default value is 380.
  final double height;

  /// The BoxDecoration to use around the Html editor. By default, the widget
  /// uses a thin, dark, rounded rectangle border around the widget.
  final BoxDecoration decoration;

  /// Specifies whether the widget should use a bottom sheet or a dialog to provide the image
  /// picking options. The dialog is similar to an Android intent dialog.
  ///
  /// The default value is true.
  final bool useBottomSheet;

  /// Specifies the width of an image when it is inserted into the Html editor
  /// as a percentage (between 0 and 100).
  ///
  /// The default value is 100.
  final double imageWidth;

  /// Specifies whether the bottom toolbar for picking an image or copy/pasting
  /// is shown on the widget.
  ///
  /// The default value is true.
  final bool showBottomToolbar;

  /// Sets the Html editor's hint (text displayed when there is no text in the
  /// editor).
  final String hint;

  /// Gets the text from the editor and returns it as a [String].
  static Future<String> getText() async {
    await controller.evaluateJavascript(source:
    "console.log(document.getElementsByClassName('note-editable')[0].innerHTML);");
    return text;
  }

  /// Sets the text of the editor. Some pre-processing is applied to convert
  /// [String] elements like "\n" to HTML elements.
  static void setText(String text) {
    String txtIsi = text
        .replaceAll("'", '\\"')
        .replaceAll('"', '\\"')
        .replaceAll("[", "\\[")
        .replaceAll("]", "\\]")
        .replaceAll("\n", "<br/>")
        .replaceAll("\n\n", "<br/>")
        .replaceAll("\r", " ")
        .replaceAll('\r\n', " ");
    String txt =
        "document.getElementsByClassName('note-editable')[0].innerHTML = '" +
            txtIsi +
            "';";
    controller.evaluateJavascript(source: txt);
  }

  /// Sets the editor to full-screen mode.
  static void setFullScreen() {
    controller.evaluateJavascript(source:
    '\$("#summernote").summernote("fullscreen.toggle");');
  }

  /// Sets the focus to the editor.
  static void setFocus() {
    controller.evaluateJavascript(source: "\$('#summernote').summernote('focus');");
  }

  /// Clears the editor of any text.
  static void clear() {
    controller.evaluateJavascript(source: "\$('#summernote').summernote('reset');");
  }

  /// Sets the hint for the editor.
  static void setHint(String text) {
    String hint = '\$(".note-placeholder").html("$text");';
    controller.evaluateJavascript(source: hint);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: decoration ??
          BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            border: Border.all(color: Color(0xffececec), width: 1),
          ),
      child: HtmlEditorWidget(
        key: key,
        value: initialText,
        height: height,
        useBottomSheet: useBottomSheet,
        imageWidth: imageWidth,
        showBottomToolbar: showBottomToolbar,
        hint: hint
      ),
    );
  }
}
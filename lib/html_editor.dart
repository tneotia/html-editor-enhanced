library html_editor;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html_editor_enhanced/html_editor_widget.dart';

InAppWebViewController controller;
String text = "";

class HtmlEditor extends StatelessWidget with WidgetsBindingObserver {
  HtmlEditor({
    Key key,
    this.value,
    this.height = 380,
    this.decoration,
    this.useBottomSheet = true,
    this.imageWidth = "100%",
    this.showBottomToolbar = true,
    this.hint
  }) : super(key: key);

  final String value;
  final double height;
  final BoxDecoration decoration;
  final bool useBottomSheet;
  final String imageWidth;
  final bool showBottomToolbar;
  final String hint;

  static Future<String> getText() async {
    await controller.evaluateJavascript(source:
    "console.log(document.getElementsByClassName('note-editable')[0].innerHTML);");
    return text;
  }

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

  static void setFullScreen() {
    controller.evaluateJavascript(source:
    '\$("#summernote").summernote("fullscreen.toggle");');
  }

  static void setFocus() {
    controller.evaluateJavascript(source: "\$('#summernote').summernote('focus');");
  }

  static void setEmpty() {
    controller.evaluateJavascript(source: "\$('#summernote').summernote('reset');");
  }

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
        value: value,
        height: height,
        useBottomSheet: useBottomSheet,
        imageWidth: imageWidth,
        showBottomToolbar: showBottomToolbar,
        hint: hint
      ),
    );
  }
}
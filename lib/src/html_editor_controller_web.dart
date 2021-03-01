import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:html_editor_enhanced/src/html_editor_controller_unsupported.dart'
    as unsupported;

/// Controller for web
class HtmlEditorController extends unsupported.HtmlEditorController {
  /// Allows the [InAppWebViewController] for the Html editor to be accessed
  /// outside of the package itself for endless control and customization.
  InAppWebViewController get editorController => throw Exception(
      "Flutter Web environment detected, please make sure you are importing package:html_editor_enhanced/html_editor.dart and check kIsWeb before accessing this getter");

  /// Gets the text from the editor and returns it as a [String].
  Future<String?> getText() async {
    html.window.onMessage.drain();
    _evaluateJavascriptWeb(data: {"type": "toIframe: getText"});
    html.MessageEvent e = await html.window.onMessage.firstWhere(
        (element) => json.decode(element.data)["type"] == "toDart: getText");
    text = json.decode(e.data)["text"];
    if (text!.isEmpty ||
        text == "<p></p>" ||
        text == "<p><br></p>" ||
        text == "<p><br/></p>") text = "";
    return text;
  }

  /// Sets the text of the editor. Some pre-processing is applied to convert
  /// [String] elements like "\n" to HTML elements.
  void setText(String text) {
    String txtIsi = text
        .replaceAll("'", '\\"')
        .replaceAll('"', '\\"')
        .replaceAll("[", "\\[")
        .replaceAll("]", "\\]")
        .replaceAll("\n", "<br/>")
        .replaceAll("\n\n", "<br/>")
        .replaceAll("\r", " ")
        .replaceAll('\r\n', " ");
    _evaluateJavascriptWeb(data: {"type": "toIframe: setText", "text": txtIsi});
  }

  /// Sets the editor to full-screen mode.
  void setFullScreen() {
    _evaluateJavascriptWeb(data: {"type": "toIframe: setFullScreen"});
  }

  /// Sets the focus to the editor.
  void setFocus() {
    _evaluateJavascriptWeb(data: {"type": "toIframe: setFocus"});
  }

  /// Clears the editor of any text.
  void clear() {
    _evaluateJavascriptWeb(data: {"type": "toIframe: clear"});
  }

  /// Sets the hint for the editor.
  void setHint(String text) {
    _evaluateJavascriptWeb(data: {"type": "toIframe: setHint", "text": text});
  }

  /// toggles the codeview in the Html editor
  void toggleCodeView() {
    _evaluateJavascriptWeb(data: {"type": "toIframe: toggleCodeview"});
  }

  /// disables the Html editor
  void disable() {
    _evaluateJavascriptWeb(data: {"type": "toIframe: disable"});
  }

  /// enables the Html editor
  void enable() {
    _evaluateJavascriptWeb(data: {"type": "toIframe: enable"});
  }

  /// Undoes the last action
  void undo() {
    _evaluateJavascriptWeb(data: {"type": "toIframe: undo"});
  }

  /// Redoes the last action
  void redo() {
    _evaluateJavascriptWeb(data: {"type": "toIframe: redo"});
  }

  /// Insert text at the end of the current HTML content in the editor
  /// Note: This method should only be used for plaintext strings
  void insertText(String text) {
    _evaluateJavascriptWeb(
        data: {"type": "toIframe: insertText", "text": text});
  }

  /// Insert HTML at the position of the cursor in the editor
  /// Note: This method should not be used for plaintext strings
  void insertHtml(String html) {
    _evaluateJavascriptWeb(
        data: {"type": "toIframe: insertHtml", "html": html});
  }

  /// Insert a network image at the position of the cursor in the editor
  void insertNetworkImage(String url, {String filename = ""}) {
    _evaluateJavascriptWeb(data: {
      "type": "toIframe: insertNetworkImage",
      "url": url,
      "filename": filename
    });
  }

  /// Insert a link at the position of the cursor in the editor
  void insertLink(String text, String url, bool isNewWindow) {
    _evaluateJavascriptWeb(data: {
      "type": "toIframe: insertLink",
      "text": text,
      "url": url,
      "isNewWindow": isNewWindow
    });
  }

  /// Refresh the page
  ///
  /// Note: This should only be used in Flutter Web!!!
  void reloadWeb() {
    _evaluateJavascriptWeb(data: {"type": "toIframe: reload"});
  }

  /// Helper function to run javascript and check current environment
  void _evaluateJavascriptWeb({required Map<String, Object?> data}) async {
    if (kIsWeb) {
      data["view"] = controllerMap[this];
      final jsonEncoder = JsonEncoder();
      var json = jsonEncoder.convert(data);
      html.window.postMessage(json, "*");
    } else {
      throw Exception(
          "Non-Flutter Web environment detected, please make sure you are importing package:html_editor_enhanced/html_editor.dart");
    }
  }
}

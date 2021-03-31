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
  HtmlEditorController({
    this.processInputHtml = true,
    this.processNewLineAsBr = false,
    this.processOutputHtml = true,
  });

  /// Determines whether text processing should happen on input HTML, e.g.
  /// whether a new line should be converted to a <br>.
  ///
  /// The default value is true.
  final bool processInputHtml;

  /// Determines whether newlines (\n) should be written as <br>. This is not
  /// recommended for HTML documents.
  ///
  /// The default value is false.
  final bool processNewLineAsBr;

  /// Determines whether text processing should happen on output HTML, e.g.
  /// whether <p><br></p> is returned as "". For reference, Summernote uses
  /// that HTML as the default HTML (when no text is in the editor).
  ///
  /// The default value is true.
  final bool processOutputHtml;

  /// Allows the [InAppWebViewController] for the Html editor to be accessed
  /// outside of the package itself for endless control and customization.
  InAppWebViewController get editorController => throw Exception(
      "Flutter Web environment detected, please make sure you are importing package:html_editor_enhanced/html_editor.dart and check kIsWeb before accessing this getter");

  /// Gets the text from the editor and returns it as a [String].
  Future<String> getText() async {
    html.window.onMessage.drain();
    _evaluateJavascriptWeb(data: {"type": "toIframe: getText"});
    html.MessageEvent e = await html.window.onMessage.firstWhere(
        (element) => json.decode(element.data)["type"] == "toDart: getText");
    String text = json.decode(e.data)["text"];
    if (processOutputHtml &&
        (text.isEmpty ||
            text == "<p></p>" ||
            text == "<p><br></p>" ||
            text == "<p><br/></p>")) text = "";
    return text;
  }

  /// Sets the text of the editor. Some pre-processing is applied to convert
  /// [String] elements like "\n" to HTML elements.
  void setText(String text) {
    text = _processHtml(html: text);
    _evaluateJavascriptWeb(data: {"type": "toIframe: setText", "text": text});
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
    text = _processHtml(html: text);
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
    html = _processHtml(html: html);
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

  /// Clears the focus from the webview by hiding the keyboard, calling the
  /// clearFocus method on the [InAppWebViewController], and resetting the height
  /// in case it was changed.
  void clearFocus() {
    throw Exception(
        "Flutter Web environment detected, please make sure you are importing package:html_editor_enhanced/html_editor.dart and check kIsWeb before calling this method.");
  }

  /// Resets the height of the editor back to the original if it was changed to
  /// accommodate the keyboard. This should only be used on mobile, and only
  /// when [adjustHeightForKeyboard] is enabled.
  void resetHeight() {
    throw Exception(
        "Flutter Web environment detected, please make sure you are importing package:html_editor_enhanced/html_editor.dart and check kIsWeb before calling this method.");
  }

  /// Refresh the page
  ///
  /// Note: This should only be used in Flutter Web!!!
  void reloadWeb() {
    _evaluateJavascriptWeb(data: {"type": "toIframe: reload"});
  }

  /// Recalculates the height of the editor to remove any vertical scrolling.
  /// This method will not do anything if [autoAdjustHeight] is turned off.
  void recalculateHeight() {
    _evaluateJavascriptWeb(data: {
      "type": "toIframe: getHeight",
    });
  }

  /// Add a notification to the bottom of the editor. This is styled similar to
  /// Bootstrap alerts. You can set the HTML to be displayed in the alert,
  /// and the notificationType determines how the alert is displayed.
  void addNotification(String html, NotificationType notificationType) {
    if (notificationType == NotificationType.plaintext)
      _evaluateJavascriptWeb(data: {
        "type": "toIframe: addNotification",
        "html": html
      });
    else
      _evaluateJavascriptWeb(data: {
        "type": "toIframe: addNotification",
        "html": html,
        "alertType": "alert alert-${describeEnum(notificationType)}"
      });
    recalculateHeight();
  }

  /// Remove the current notification from the bottom of the editor
  void removeNotification() {
    _evaluateJavascriptWeb(data: {
      "type": "toIframe: removeNotification"
    });
    recalculateHeight();
  }

  String _processHtml({required html}) {
    if (processInputHtml) {
      html = html
          .replaceAll("'", r"\'")
          .replaceAll('"', r'\"')
          .replaceAll("\r", "")
          .replaceAll('\r\n', "");
    }
    if (processNewLineAsBr) {
      html = html.replaceAll("\n", "<br/>").replaceAll("\n\n", "<br/>");
    } else {
      html = html.replaceAll("\n", "").replaceAll("\n\n", "");
    }
    return html;
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

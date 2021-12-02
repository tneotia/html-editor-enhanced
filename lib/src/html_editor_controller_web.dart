import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:html_editor_enhanced/src/html_editor_controller_unsupported.dart'
    as unsupported;
import 'package:meta/meta.dart';

/// Controller for web
class HtmlEditorController extends unsupported.HtmlEditorController {
  HtmlEditorController({
    this.processInputHtml = true,
    this.processNewLineAsBr = false,
    this.processOutputHtml = true,
  });

  /// Toolbar widget state to call various methods. For internal use only.
  @override
  ToolbarWidgetState? toolbar;

  /// Determines whether text processing should happen on input HTML, e.g.
  /// whether a new line should be converted to a <br>.
  ///
  /// The default value is true.
  @override
  final bool processInputHtml;

  /// Determines whether newlines (\n) should be written as <br>. This is not
  /// recommended for HTML documents.
  ///
  /// The default value is false.
  @override
  final bool processNewLineAsBr;

  /// Determines whether text processing should happen on output HTML, e.g.
  /// whether <p><br></p> is returned as "". For reference, Summernote uses
  /// that HTML as the default HTML (when no text is in the editor).
  ///
  /// The default value is true.
  @override
  final bool processOutputHtml;

  /// Manages the view ID for the [HtmlEditorController] on web
  String? _viewId;

  /// Internal method to set the view ID when iframe initialization
  /// is complete
  @override
  @internal
  set viewId(String? viewId) => _viewId = viewId;

  /// Gets the text from the editor and returns it as a [String].
  @override
  Future<String> getText() async {
    _evaluateJavascriptWeb(data: {'type': 'toIframe: getText'});
    var e = await html.window.onMessage.firstWhere(
        (element) => json.decode(element.data)['type'] == 'toDart: getText');
    String text = json.decode(e.data)['text'];
    if (processOutputHtml &&
        (text.isEmpty ||
            text == '<p></p>' ||
            text == '<p><br></p>' ||
            text == '<p><br/></p>')) text = '';
    return text;
  }

  @override
  Future<String> getSelectedTextWeb({bool withHtmlTags = false}) async {
    if (withHtmlTags) {
      _evaluateJavascriptWeb(data: {'type': 'toIframe: getSelectedTextHtml'});
    } else {
      _evaluateJavascriptWeb(data: {'type': 'toIframe: getSelectedText'});
    }
    var e = await html.window.onMessage.firstWhere((element) =>
        json.decode(element.data)['type'] == 'toDart: getSelectedText');
    return json.decode(e.data)['text'];
  }

  /// Sets the text of the editor. Some pre-processing is applied to convert
  /// [String] elements like "\n" to HTML elements.
  @override
  void setText(String text) {
    text = _processHtml(html: text);
    _evaluateJavascriptWeb(data: {'type': 'toIframe: setText', 'text': text});
  }

  /// Sets the editor to full-screen mode.
  @override
  void setFullScreen() {
    _evaluateJavascriptWeb(data: {'type': 'toIframe: setFullScreen'});
  }

  /// Sets the focus to the editor.
  @override
  void setFocus() {
    _evaluateJavascriptWeb(data: {'type': 'toIframe: setFocus'});
  }

  /// Clears the editor of any text.
  @override
  void clear() {
    _evaluateJavascriptWeb(data: {'type': 'toIframe: clear'});
  }

  /// Sets the hint for the editor.
  @override
  void setHint(String text) {
    text = _processHtml(html: text);
    _evaluateJavascriptWeb(data: {'type': 'toIframe: setHint', 'text': text});
  }

  /// toggles the codeview in the Html editor
  @override
  void toggleCodeView() {
    _evaluateJavascriptWeb(data: {'type': 'toIframe: toggleCodeview'});
  }

  /// disables the Html editor
  @override
  void disable() {
    toolbar!.disable();
    _evaluateJavascriptWeb(data: {'type': 'toIframe: disable'});
  }

  /// enables the Html editor
  @override
  void enable() {
    toolbar!.enable();
    _evaluateJavascriptWeb(data: {'type': 'toIframe: enable'});
  }

  /// Undoes the last action
  @override
  void undo() {
    _evaluateJavascriptWeb(data: {'type': 'toIframe: undo'});
  }

  /// Redoes the last action
  @override
  void redo() {
    _evaluateJavascriptWeb(data: {'type': 'toIframe: redo'});
  }

  /// Insert text at the end of the current HTML content in the editor
  /// Note: This method should only be used for plaintext strings
  @override
  void insertText(String text) {
    _evaluateJavascriptWeb(
        data: {'type': 'toIframe: insertText', 'text': text});
  }

  /// Insert HTML at the position of the cursor in the editor
  /// Note: This method should not be used for plaintext strings
  @override
  void insertHtml(String html) {
    html = _processHtml(html: html);
    _evaluateJavascriptWeb(
        data: {'type': 'toIframe: insertHtml', 'html': html});
  }

  /// Insert a network image at the position of the cursor in the editor
  @override
  void insertNetworkImage(String url, {String filename = ''}) {
    _evaluateJavascriptWeb(data: {
      'type': 'toIframe: insertNetworkImage',
      'url': url,
      'filename': filename
    });
  }

  /// Insert a link at the position of the cursor in the editor
  @override
  void insertLink(String text, String url, bool isNewWindow) {
    _evaluateJavascriptWeb(data: {
      'type': 'toIframe: insertLink',
      'text': text,
      'url': url,
      'isNewWindow': isNewWindow
    });
  }

  /// Clears the focus from the webview by hiding the keyboard, calling the
  /// clearFocus method on the [InAppWebViewController], and resetting the height
  /// in case it was changed.
  @override
  void clearFocus() {
    throw Exception(
        'Flutter Web environment detected, please make sure you are importing package:html_editor_enhanced/html_editor.dart and check kIsWeb before calling this method.');
  }

  /// Resets the height of the editor back to the original if it was changed to
  /// accommodate the keyboard. This should only be used on mobile, and only
  /// when [adjustHeightForKeyboard] is enabled.
  @override
  void resetHeight() {
    throw Exception(
        'Flutter Web environment detected, please make sure you are importing package:html_editor_enhanced/html_editor.dart and check kIsWeb before calling this method.');
  }

  /// Refresh the page
  ///
  /// Note: This should only be used in Flutter Web!!!
  @override
  void reloadWeb() {
    _evaluateJavascriptWeb(data: {'type': 'toIframe: reload'});
  }

  /// Recalculates the height of the editor to remove any vertical scrolling.
  /// This method will not do anything if [autoAdjustHeight] is turned off.
  @override
  void recalculateHeight() {
    _evaluateJavascriptWeb(data: {
      'type': 'toIframe: getHeight',
    });
  }

  /// A function to quickly call a document.execCommand function in a readable format
  @override
  void execCommand(String command, {String? argument}) {
    _evaluateJavascriptWeb(data: {
      'type': 'toIframe: execCommand',
      'command': command,
      'argument': argument
    });
  }

  /// A function to execute JS passed as a [WebScript] to the editor. This should
  /// only be used on Flutter Web.
  @override
  Future<dynamic> evaluateJavascriptWeb(String name,
      {bool hasReturnValue = false}) async {
    _evaluateJavascriptWeb(data: {'type': 'toIframe: $name'});
    if (hasReturnValue) {
      var e = await html.window.onMessage.firstWhere(
          (element) => json.decode(element.data)['type'] == 'toDart: $name');
      return json.decode(e.data);
    }
  }

  /// Internal function to change list style on Web
  @override
  void changeListStyle(String changed) {
    _evaluateJavascriptWeb(
        data: {'type': 'toIframe: changeListStyle', 'changed': changed});
  }

  /// Internal function to change line height on Web
  @override
  void changeLineHeight(String changed) {
    _evaluateJavascriptWeb(
        data: {'type': 'toIframe: changeLineHeight', 'changed': changed});
  }

  /// Internal function to change text direction on Web
  @override
  void changeTextDirection(String direction) {
    _evaluateJavascriptWeb(data: {
      'type': 'toIframe: changeTextDirection',
      'direction': direction
    });
  }

  /// Internal function to change case on Web
  @override
  void changeCase(String changed) {
    _evaluateJavascriptWeb(
        data: {'type': 'toIframe: changeCase', 'case': changed});
  }

  /// Internal function to insert table on Web
  @override
  void insertTable(String dimensions) {
    _evaluateJavascriptWeb(
        data: {'type': 'toIframe: insertTable', 'dimensions': dimensions});
  }

  /// Add a notification to the bottom of the editor. This is styled similar to
  /// Bootstrap alerts. You can set the HTML to be displayed in the alert,
  /// and the notificationType determines how the alert is displayed.
  @override
  void addNotification(String html, NotificationType notificationType) {
    if (notificationType == NotificationType.plaintext) {
      _evaluateJavascriptWeb(
          data: {'type': 'toIframe: addNotification', 'html': html});
    } else {
      _evaluateJavascriptWeb(data: {
        'type': 'toIframe: addNotification',
        'html': html,
        'alertType': 'alert alert-${describeEnum(notificationType)}'
      });
    }
    recalculateHeight();
  }

  /// Remove the current notification from the bottom of the editor
  @override
  void removeNotification() {
    _evaluateJavascriptWeb(data: {'type': 'toIframe: removeNotification'});
    recalculateHeight();
  }

  /// Helper function to process input html
  String _processHtml({required html}) {
    if (processInputHtml) {
      html = html.replaceAll('\r', '').replaceAll('\r\n', '');
    }
    if (processNewLineAsBr) {
      html = html.replaceAll('\n', '<br/>').replaceAll('\n\n', '<br/>');
    } else {
      html = html.replaceAll('\n', '').replaceAll('\n\n', '');
    }
    return html;
  }

  /// Helper function to run javascript and check current environment
  void _evaluateJavascriptWeb({required Map<String, Object?> data}) async {
    if (kIsWeb) {
      data['view'] = _viewId;
      final jsonEncoder = JsonEncoder();
      var json = jsonEncoder.convert(data);
      html.window.postMessage(json, '*');
    } else {
      throw Exception(
          'Non-Flutter Web environment detected, please make sure you are importing package:html_editor_enhanced/html_editor.dart');
    }
  }
}

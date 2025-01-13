import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:html_editor_enhanced/src/html_editor_controller_unsupported.dart'
    as unsupported;

/// Controller for mobile
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
  /// The default value is false.
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

  /// Manages the [InAppWebViewController] for the [HtmlEditorController]
  InAppWebViewController? _editorController;

  /// Allows the [InAppWebViewController] for the Html editor to be accessed
  /// outside of the package itself for endless control and customization.
  @override
  // ignore: unnecessary_getters_setters
  InAppWebViewController? get editorController => _editorController;

  /// Internal method to set the [InAppWebViewController] when webview initialization
  /// is complete
  @override
  // ignore: unnecessary_getters_setters
  set editorController(dynamic controller) =>
      _editorController = controller as InAppWebViewController?;

  /// A function to quickly call a document.execCommand function in a readable format
  @override
  void execCommand(String command, {String? argument}) {
    _evaluateJavascript(
        source:
            "document.execCommand('$command', false${argument == null ? "" : ", '$argument'"});");
  }

  /// Gets the text from the editor and returns it as a [String].
  @override
  Future<String> getText() async {
    var text = await _evaluateJavascript(
        source: "\$('#summernote-2').summernote('code');") as String?;
    if (processOutputHtml &&
        (text == null ||
            text.isEmpty ||
            text == '<p></p>' ||
            text == '<p><br></p>' ||
            text == '<p><br/></p>')) text = '';
    return text ?? '';
  }

  /// Sets the text of the editor. Some pre-processing is applied to convert
  /// [String] elements like "\n" to HTML elements.
  @override
  void setText(String text) {
    text = _processHtml(html: text);
    _evaluateJavascript(
        source: "\$('#summernote-2').summernote('code', '$text');");
  }

  /// Sets the editor to full-screen mode.
  @override
  void setFullScreen() {
    _evaluateJavascript(
        source: '\$("#summernote-2").summernote("fullscreen.toggle");');
  }

  /// Sets the focus to the editor.
  @override
  void setFocus() {
    _evaluateJavascript(source: "\$('#summernote-2').summernote('focus');");
  }

  /// Clears the editor of any text.
  @override
  void clear() {
    _evaluateJavascript(source: "\$('#summernote-2').summernote('reset');");
  }

  /// Sets the hint for the editor.
  @override
  void setHint(String text) {
    text = _processHtml(html: text);
    var hint = '\$(".note-placeholder").html("$text");';
    _evaluateJavascript(source: hint);
  }

  /// toggles the codeview in the Html editor
  @override
  void toggleCodeView() {
    _evaluateJavascript(
        source: "\$('#summernote-2').summernote('codeview.toggle');");
  }

  /// disables the Html editor
  @override
  void disable() {
    toolbar!.disable();
    _evaluateJavascript(source: "\$('#summernote-2').summernote('disable');");
  }

  /// enables the Html editor
  @override
  void enable() {
    toolbar!.enable();
    _evaluateJavascript(source: "\$('#summernote-2').summernote('enable');");
  }

  /// Undoes the last action
  @override
  void undo() {
    _evaluateJavascript(source: "\$('#summernote-2').summernote('undo');");
  }

  /// Redoes the last action
  @override
  void redo() {
    _evaluateJavascript(source: "\$('#summernote-2').summernote('redo');");
  }

  /// Insert text at the end of the current HTML content in the editor
  /// Note: This method should only be used for plaintext strings
  @override
  void insertText(String text) {
    _evaluateJavascript(
        source: "\$('#summernote-2').summernote('insertText', '$text');");
  }

  /// Insert HTML at the position of the cursor in the editor
  /// Note: This method should not be used for plaintext strings
  @override
  void insertHtml(String html) {
    html = _processHtml(html: html);
    _evaluateJavascript(
        source: "\$('#summernote-2').summernote('pasteHTML', '$html');");
  }

  /// Insert a network image at the position of the cursor in the editor
  @override
  void insertNetworkImage(String url, {String filename = ''}) {
    _evaluateJavascript(
        source:
            "\$('#summernote-2').summernote('insertImage', '$url', '$filename');");
  }

  /// Insert a link at the position of the cursor in the editor
  @override
  void insertLink(String text, String url, bool isNewWindow) {
    _evaluateJavascript(source: """
    \$('#summernote-2').summernote('createLink', {
        text: "$text",
        url: '$url',
        isNewWindow: $isNewWindow
      });
    """);
  }

  /// Clears the focus from the webview by hiding the keyboard, calling the
  /// clearFocus method on the [InAppWebViewController], and resetting the height
  /// in case it was changed.
  @override
  void clearFocus() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  /// Reloads the IFrameElement, throws an exception on mobile
  @override
  void reloadWeb() {
    throw Exception(
        'Non-Flutter Web environment detected, please make sure you are importing package:html_editor_enhanced/html_editor.dart and check kIsWeb before calling this function');
  }

  /// Resets the height of the editor back to the original if it was changed to
  /// accommodate the keyboard. This should only be used on mobile, and only
  /// when [adjustHeightForKeyboard] is enabled.
  @override
  void resetHeight() {
    _evaluateJavascript(
        source:
            "window.flutter_inappwebview.callHandler('setHeight', 'reset');");
  }

  /// Recalculates the height of the editor to remove any vertical scrolling.
  /// This method will not do anything if [autoAdjustHeight] is turned off.
  @override
  void recalculateHeight() {
    _evaluateJavascript(
        source:
            "var height = document.body.scrollHeight; window.flutter_inappwebview.callHandler('setHeight', height);");
  }

  /// Add a notification to the bottom of the editor. This is styled similar to
  /// Bootstrap alerts. You can set the HTML to be displayed in the alert,
  /// and the notificationType determines how the alert is displayed.
  @override
  void addNotification(String html, NotificationType notificationType) async {
    await _evaluateJavascript(source: """
        \$('.note-status-output').html(
          '<div class="alert alert-${describeEnum(notificationType)}">$html</div>'
        );
        """);
    recalculateHeight();
  }

  /// Remove the current notification from the bottom of the editor
  @override
  void removeNotification() async {
    await _evaluateJavascript(source: "\$('.note-status-output').empty();");
    recalculateHeight();
  }

  /// Helper function to process input html
  String _processHtml({required html}) {
    if (processInputHtml) {
      html = html
          .replaceAll("'", r"\'")
          .replaceAll('"', r'\"')
          .replaceAll('\r', '')
          .replaceAll('\r\n', '');
    }
    if (processNewLineAsBr) {
      html = html.replaceAll('\n', '<br/>').replaceAll('\n\n', '<br/>');
    } else {
      html = html.replaceAll('\n', '').replaceAll('\n\n', '');
    }
    return html;
  }

  /// Helper function to evaluate JS and check the current environment
  dynamic _evaluateJavascript({required source}) async {
    if (!kIsWeb) {
      if (editorController == null || await editorController!.isLoading()) {
        throw Exception(
            'HTML editor is still loading, please wait before evaluating this JS: $source!');
      }
      var result = await editorController!.evaluateJavascript(source: source);
      return result;
    } else {
      throw Exception(
          'Flutter Web environment detected, please make sure you are importing package:html_editor_enhanced/html_editor.dart');
    }
  }

  /// Internal function to change list style on Web
  @override
  void changeListStyle(String changed) {}

  /// Internal function to change line height on Web
  @override
  void changeLineHeight(String changed) {}

  /// Internal function to change text direction on Web
  @override
  void changeTextDirection(String changed) {}

  /// Internal function to change case on Web
  @override
  void changeCase(String changed) {}

  /// Internal function to insert table on Web
  @override
  void insertTable(String dimensions) {}
}

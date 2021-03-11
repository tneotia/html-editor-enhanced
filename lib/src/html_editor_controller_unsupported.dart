import 'dart:async';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// Fallback controller (should never be used)
class HtmlEditorController {
  /// Allows the [InAppWebViewController] for the Html editor to be accessed
  /// outside of the package itself for endless control and customization.
  InAppWebViewController? get editorController => null;

  /// Stream to get the text once the javascript execution is complete.
  /// It is *not* recommended to modify or use this property in your code, this
  /// is only exposed so the [InAppWebView] can access it.
  StreamController<String>? getTextStream;

  /// Method to dispose the stream that gets text from the editor. It is
  /// highly recommended to use this method in your [dispose] for your [StatefulWidget].
  ///
  /// Note: This should only be used in Flutter Mobile, Flutter Web does not
  /// use a stream and therefore nothing needs to be disposed.
  void dispose() {
    if (getTextStream != null) getTextStream?.close();
  }

  /// Gets the text from the editor and returns it as a [String].
  Future<String?> getText() => Future.value(null);

  /// Sets the text of the editor. Some pre-processing is applied to convert
  /// [String] elements like "\n" to HTML elements.
  void setText(String text) {}

  /// Sets the editor to full-screen mode.
  void setFullScreen() {}

  /// Sets the focus to the editor.
  void setFocus() {}

  /// Clears the editor of any text.
  void clear() {}

  /// Sets the hint for the editor.
  void setHint(String text) {}

  /// toggles the codeview in the Html editor
  void toggleCodeView() {}

  /// disables the Html editor
  void disable() {}

  /// enables the Html editor
  void enable() {}

  /// Undoes the last action
  void undo() {}

  /// Redoes the last action
  void redo() {}

  /// Insert text at the end of the current HTML content in the editor
  /// Note: This method should only be used for plaintext strings
  void insertText(String text) {}

  /// Insert HTML at the position of the cursor in the editor
  /// Note: This method should not be used for plaintext strings
  void insertHtml(String html) {}

  /// Insert a network image at the position of the cursor in the editor
  void insertNetworkImage(String url, {String filename = ""}) {}

  /// Insert a link at the position of the cursor in the editor
  void insertLink(String text, String url, bool isNewWindow) {}

  /// Refresh the page
  ///
  /// Note: This should only be used in Flutter Web!!!
  void reloadWeb() {}
}

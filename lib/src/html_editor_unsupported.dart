export 'dart:html';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:html_editor_enhanced/src/html_editor_impl.dart';

class HtmlEditor extends StatelessWidget implements HtmlEditorImpl {
  HtmlEditor({
    Key key,
    this.initialText,
    this.height = 380,
    this.decoration,
    this.showBottomToolbar = true,
    this.hint,
    this.callbacks,
    this.toolbar = const [
      Style(),
      Font(buttons: [
        FontButtons.bold,
        FontButtons.underline,
        FontButtons.clear
      ]),
      ColorBar(buttons: [ColorButtons.color]),
      Paragraph(buttons: [
        ParagraphButtons.ul,
        ParagraphButtons.ol,
        ParagraphButtons.paragraph
      ]),
      Insert(buttons: [
        InsertButtons.link,
        InsertButtons.picture,
        InsertButtons.video,
        InsertButtons.table
      ]),
      Misc(buttons: [
        MiscButtons.fullscreen,
        MiscButtons.codeview,
        MiscButtons.help
      ])
    ],
    this.darkMode,
  }) : super(key: key);

  /// The initial text that is be supplied to the Html editor.
  @override
  final String initialText;

  /// Sets the height of the Html editor. If you decide to show the bottom toolbar,
  /// this height will be inclusive of the space the toolbar takes up.
  ///
  /// The default value is 380.
  @override
  final double height;

  /// The BoxDecoration to use around the Html editor. By default, the widget
  /// uses a thin, dark, rounded rectangle border around the widget.
  @override
  final BoxDecoration decoration;

  /// Specifies whether the bottom toolbar for picking an image or copy/pasting
  /// is shown on the widget.
  ///
  /// The default value is true.
  @override
  final bool showBottomToolbar;

  /// Sets the Html editor's hint (text displayed when there is no text in the
  /// editor).
  @override
  final String hint;

  /// Sets & activates Summernote's callbacks. See the functions available in
  /// [Callbacks] for more details.
  @override
  final Callbacks callbacks;

  /// Sets which options are visible in the toolbar for the editor.
  @override
  final List<Toolbar> toolbar;

  /// Sets the editor to dark mode. `null` - switches with system, `false` -
  /// always light, `true` - always dark.
  ///
  /// The default value is null (switches with system).
  @override
  final bool darkMode;

  /// Allows the [InAppWebViewController] for the Html editor to be accessed
  /// outside of the package itself for endless control and customization.
  static InAppWebViewController get editorController => null;

  /// Gets the text from the editor and returns it as a [String].
  static Future<String> getText() async {
    return Future.value("impl");
  }

  /// Sets the text of the editor. Some pre-processing is applied to convert
  /// [String] elements like "\n" to HTML elements.
  static void setText(String text) {}

  /// Sets the editor to full-screen mode.
  static void setFullScreen() {}

  /// Sets the focus to the editor.
  static void setFocus() {}

  /// Clears the editor of any text.
  static void clear() {}

  /// Sets the hint for the editor.
  static void setHint(String text) {}

  /// toggles the codeview in the Html editor
  static void toggleCodeView() {}

  /// disables the Html editor
  static void disable() {}

  /// enables the Html editor
  static void enable() {}

  /// Undoes the last action
  static void undo() {}

  /// Redoes the last action
  static void redo() {}

  /// Insert text at the end of the current HTML content in the editor
  /// Note: This method should only be used for plaintext strings
  static void insertText(String text) {}

  /// Insert HTML at the position of the cursor in the editor
  /// Note: This method should not be used for plaintext strings
  static void insertHtml(String html) {}

  /// Insert a network image at the position of the cursor in the editor
  static void insertNetworkImage(String url, {String filename = ""}) {}

  /// Insert a link at the position of the cursor in the editor
  static void insertLink(String text, String url, bool isNewWindow) {}

  /// Refresh the page
  ///
  /// Note: This should only be used in Flutter Web!!!
  static void reloadWeb() {}

  static Future evaluateJavascript({@required source}) async {}

  static void evaluateJavascriptWeb(
      {@required Map<String, Object> data}) async {}

  @override
  Widget build(BuildContext context) {
    return Text("Unsupported in this environment");
  }
}

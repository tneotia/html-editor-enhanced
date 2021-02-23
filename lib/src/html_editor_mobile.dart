import 'package:html_editor_enhanced/html_editor.dart';
import 'package:html_editor_enhanced/src/html_editor_impl.dart';
import 'package:html_editor_enhanced/src/widgets/html_editor_widget_mobile.dart'
    as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html_editor_enhanced/utils/callbacks.dart';
import 'package:html_editor_enhanced/utils/toolbar.dart';

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
  static InAppWebViewController get editorController => controller;

  /// Gets the text from the editor and returns it as a [String].
  static Future<String> getText() async {
    await evaluateJavascript(
        source:
            "var str = \$('#summernote-2').summernote('code'); console.log(str);");
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
    evaluateJavascript(
        source: "\$('#summernote-2').summernote('code', '$txtIsi');");
  }

  /// Sets the editor to full-screen mode.
  static void setFullScreen() {
    evaluateJavascript(
        source: '\$("#summernote-2").summernote("fullscreen.toggle");');
  }

  /// Sets the focus to the editor.
  static void setFocus() {
    evaluateJavascript(source: "\$('#summernote-2').summernote('focus');");
  }

  /// Clears the editor of any text.
  static void clear() {
    evaluateJavascript(source: "\$('#summernote-2').summernote('reset');");
  }

  /// Sets the hint for the editor.
  static void setHint(String text) {
    String hint = '\$(".note-placeholder").html("$text");';
    evaluateJavascript(source: hint);
  }

  /// toggles the codeview in the Html editor
  static void toggleCodeView() {
    evaluateJavascript(
        source: "\$('#summernote-2').summernote('codeview.toggle');");
  }

  /// disables the Html editor
  static void disable() {
    evaluateJavascript(source: "\$('#summernote-2').summernote('disable');");
  }

  /// enables the Html editor
  static void enable() {
    evaluateJavascript(source: "\$('#summernote-2').summernote('enable');");
  }

  /// Undoes the last action
  static void undo() {
    evaluateJavascript(source: "\$('#summernote-2').summernote('undo');");
  }

  /// Redoes the last action
  static void redo() {
    evaluateJavascript(source: "\$('#summernote-2').summernote('redo');");
  }

  /// Insert text at the end of the current HTML content in the editor
  /// Note: This method should only be used for plaintext strings
  static void insertText(String text) {
    evaluateJavascript(
        source: "\$('#summernote-2').summernote('insertText', '$text');");
  }

  /// Insert HTML at the position of the cursor in the editor
  /// Note: This method should not be used for plaintext strings
  static void insertHtml(String html) {
    evaluateJavascript(
        source: "\$('#summernote-2').summernote('pasteHTML', '$html');");
  }

  /// Insert a network image at the position of the cursor in the editor
  static void insertNetworkImage(String url, {String filename = ""}) {
    evaluateJavascript(
        source:
            "\$('#summernote-2').summernote('insertImage', '$url', '$filename');");
  }

  /// Insert a link at the position of the cursor in the editor
  static void insertLink(String text, String url, bool isNewWindow) {
    evaluateJavascript(source: """
    \$('#summernote-2').summernote('createLink', {
        text: "$text",
        url: '$url',
        isNewWindow: $isNewWindow
      });
    """);
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return Container(
        height: height,
        decoration: decoration ??
            BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              border: Border.all(color: Color(0xffececec), width: 1),
            ),
        child: html.HtmlEditorWidget(
          key: key,
          value: initialText,
          height: height,
          showBottomToolbar: showBottomToolbar,
          hint: hint,
          callbacks: callbacks,
          toolbar: toolbar.isEmpty
              ? [
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
                ]
              : toolbar,
          darkMode: darkMode,
        ),
      );
    } else {
      return Text(
          "Flutter Web environment detected, please make sure you are importing package:html_editor_enhanced/html_editor.dart");
    }
  }

  static reloadWeb() {
    throw Exception(
        "Non-Flutter Web environment detected, please make sure you are importing package:html_editor_enhanced/html_editor.dart and check kIsWeb before calling this function");
  }

  static Future evaluateJavascript({@required source}) async {
    if (!kIsWeb) {
      if (controller == null || await controller.isLoading())
        throw Exception(
            "HTML editor is still loading, please wait before evaluating this JS: $source!");
      await controller.evaluateJavascript(source: source);
    } else {
      throw Exception(
          "Flutter Web environment detected, please make sure you are importing package:html_editor_enhanced/html_editor.dart");
    }
  }
}

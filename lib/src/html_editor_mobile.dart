import 'package:html_editor_enhanced/html_editor.dart';
import 'package:html_editor_enhanced/src/html_editor_impl.dart';
import 'package:html_editor_enhanced/src/widgets/html_editor_widget_mobile.dart'
    as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/utils/callbacks.dart';
import 'package:html_editor_enhanced/utils/toolbar.dart';

class HtmlEditor extends StatelessWidget implements HtmlEditorImpl {
  HtmlEditor({
    Key key,
    @required this.controller,
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

  /// The controller that is passed to the widget, which allows multiple [HtmlEditor]
  /// widgets to be used on the same page independently.
  @override
  final HtmlEditorController controller;

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
          widgetController: controller,
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
}

import 'package:html_editor_enhanced/html_editor.dart';
import 'package:html_editor_enhanced/src/widgets/html_editor_widget_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/utils/callbacks.dart';
import 'package:html_editor_enhanced/utils/plugins.dart';
import 'package:html_editor_enhanced/utils/toolbar.dart';

/// HtmlEditor class for web
class HtmlEditor extends StatelessWidget {
  HtmlEditor({
    Key? key,
    required this.controller,
    this.initialText,
    this.hint,
    this.callbacks,
    this.toolbar = const [],
    this.plugins = const [],
    this.options = const HtmlEditorOptions(),
  }) : super(key: key);

  /// The controller that is passed to the widget, which allows multiple [HtmlEditor]
  /// widgets to be used on the same page independently.
  final HtmlEditorController controller;

  /// The initial text that is be supplied to the Html editor.
  final String? initialText;

  /// Sets the Html editor's hint (text displayed when there is no text in the
  /// editor).
  final String? hint;

  /// Sets & activates Summernote's callbacks. See the functions available in
  /// [Callbacks] for more details.
  final Callbacks? callbacks;

  /// Sets which options are visible in the toolbar for the editor.
  final List<Toolbar> toolbar;

  /// Sets the list of Summernote plugins enabled in the editor.
  final List<Plugins> plugins;

  /// Defines miscellaneous options for the editor
  final HtmlEditorOptions options;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return HtmlEditorWidget(
        key: key,
        controller: controller,
        value: initialText,
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
        plugins: plugins,
        initBC: context,
        options: options,
      );
    } else {
      return Text(
          "Non-Flutter Web environment detected, please make sure you are importing package:html_editor_enhanced/html_editor.dart");
    }
  }
}

import 'package:html_editor_enhanced/html_editor.dart';
import 'package:html_editor_enhanced/src/widgets/html_editor_widget_mobile.dart'
    as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/utils/callbacks.dart';
import 'package:html_editor_enhanced/utils/plugins.dart';
import 'package:html_editor_enhanced/utils/toolbar.dart';

/// HtmlEditor class for mobile
class HtmlEditor extends StatelessWidget {
  HtmlEditor({
    Key? key,
    required this.controller,
    this.initialText,
    this.height = 380,
    this.autoAdjustHeight = true,
    this.decoration = const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      border: Border.fromBorderSide(BorderSide(color: const Color(0xffececec), width: 1)),
    ),
    this.showBottomToolbar = true,
    this.hint,
    this.callbacks,
    this.toolbar = const [],
    this.plugins = const [],
    this.darkMode,
  }) : super(key: key);

  /// The controller that is passed to the widget, which allows multiple [HtmlEditor]
  /// widgets to be used on the same page independently.
  final HtmlEditorController controller;

  /// The initial text that is be supplied to the Html editor.
  final String? initialText;

  /// Sets the height of the Html editor space. It does not take the toolbar
  /// for the editor into account.
  ///
  /// The default value is 380.
  final double height;

  /// The editor will automatically adjust its height once the page is loaded to
  /// ensure there is no vertical scrolling or empty space. It will only perform
  /// the adjustment when the summernote editor is the loaded page.
  ///
  /// The default value is true.
  final bool autoAdjustHeight;

  /// The BoxDecoration to use around the Html editor. By default, the widget
  /// uses a thin, dark, rounded rectangle border around the widget.
  final BoxDecoration decoration;

  /// Specifies whether the bottom toolbar for picking an image or copy/pasting
  /// is shown on the widget.
  ///
  /// The default value is true.
  final bool showBottomToolbar;

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

  /// Sets the editor to dark mode. `null` - switches with system, `false` -
  /// always light, `true` - always dark.
  ///
  /// The default value is null (switches with system).
  final bool? darkMode;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return html.HtmlEditorWidget(
        key: key,
        controller: controller,
        value: initialText,
        height: height,
        autoAdjustHeight: autoAdjustHeight,
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
        plugins: plugins,
        darkMode: darkMode,
        decoration: decoration
      );
    } else {
      return Text(
          "Flutter Web environment detected, please make sure you are importing package:html_editor_enhanced/html_editor.dart");
    }
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:html_editor_enhanced/src/html_editor_controller_unsupported.dart';
import 'package:html_editor_enhanced/utils/plugins.dart';

/// Fallback HtmlEditor class (should never be called)
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
    return Text("Unsupported in this environment");
  }
}

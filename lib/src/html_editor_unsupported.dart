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
    this.callbacks,
    this.hint,
    this.initialText,
    this.options = const HtmlEditorOptions(),
    this.plugins = const [],
    this.toolbar = const [],
  }) : super(key: key);

  /// The controller that is passed to the widget, which allows multiple [HtmlEditor]
  /// widgets to be used on the same page independently.
  final HtmlEditorController controller;

  /// Sets & activates Summernote's callbacks. See the functions available in
  /// [Callbacks] for more details.
  final Callbacks? callbacks;

  /// Sets the Html editor's hint (text displayed when there is no text in the
  /// editor).
  final String? hint;

  /// The initial text that is be supplied to the Html editor.
  final String? initialText;

  /// Defines miscellaneous options for the editor
  final HtmlEditorOptions options;

  /// Sets the list of Summernote plugins enabled in the editor.
  final List<Plugins> plugins;

  /// Sets which options are visible in the toolbar for the editor.
  final List<Toolbar> toolbar;

  @override
  Widget build(BuildContext context) {
    return Text("Unsupported in this environment");
  }
}

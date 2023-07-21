import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

/// Fallback HtmlEditor class (should never be called)
class HtmlEditor extends StatelessWidget {
  HtmlEditor({
    Key? key,
    required this.controller,
    required this.onScrollToTop,
    this.callbacks,
    this.htmlEditorOptions = const HtmlEditorOptions(),
    this.htmlToolbarOptions = const HtmlToolbarOptions(),
    this.otherOptions = const OtherOptions(),
    this.plugins = const [],
    this.focusScopeNode,
  }) : super(key: key);

  /// The controller that is passed to the widget, which allows multiple [HtmlEditor]
  /// widgets to be used on the same page independently.
  final HtmlEditorController controller;

  /// Scroll to top callback
  final VoidCallback onScrollToTop;

  /// Sets & activates Summernote's callbacks. See the functions available in
  /// [Callbacks] for more details.
  final Callbacks? callbacks;

  /// Defines options for the html editor
  final HtmlEditorOptions htmlEditorOptions;

  /// Defines options for the editor toolbar
  final HtmlToolbarOptions htmlToolbarOptions;

  /// Defines other options
  final OtherOptions otherOptions;

  /// Sets the list of Summernote plugins enabled in the editor.
  final List<Plugins> plugins;

  /// FocusScopeNode for the editor (focusNode of the editor should be focusScopeNode.next())
  final FocusScopeNode? focusScopeNode;

  @override
  Widget build(BuildContext context) {
    return Text('Unsupported in this environment');
  }
}

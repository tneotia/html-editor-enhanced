import 'package:flutter/material.dart';

/// Options class for the html editor.
class HtmlEditorOptions {
  const HtmlEditorOptions({
    this.height = 380,
    this.autoAdjustHeight = true,
    this.decoration = const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      border: Border.fromBorderSide(
          BorderSide(color: const Color(0xffececec), width: 1)),
    ),
    this.showBottomToolbar = true,
    this.darkMode,
    this.filePath,
  });

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

  /// Sets the editor to dark mode. `null` - switches with system, `false` -
  /// always light, `true` - always dark.
  ///
  /// The default value is null (switches with system).
  final bool? darkMode;

  /// Specify the file path to your custom html editor code.
  ///
  /// Make sure to set the editor's HTML ID to be 'summernote-2'.
  ///
  /// If you plan to use this on Web, you must add comments in your HTML so the
  /// package can insert the relevant JS code to communicate between Dart and JS.
  /// See the README for more details on this.
  final String? filePath;
}
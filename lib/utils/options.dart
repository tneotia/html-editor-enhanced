import 'package:flutter/material.dart';

/// Options class for the html editor.
class HtmlEditorOptions {
  const HtmlEditorOptions({
    this.autoAdjustHeight = true,
    this.adjustHeightForKeyboard = true,
    this.darkMode,
    this.decoration = const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      border: Border.fromBorderSide(
          BorderSide(color: const Color(0xffececec), width: 1)),
    ),
    this.filePath,
    this.height = 380,
    this.shouldEnsureVisible = false,
    this.showBottomToolbar = true,
  });

  /// The editor will automatically adjust its height when the keyboard is active
  /// to prevent the keyboard overlapping the editor.
  ///
  /// The default value is true. It is recommended to leave this as true because
  /// it significantly improves the UX.
  final bool adjustHeightForKeyboard;

  /// The editor will automatically adjust its height once the page is loaded to
  /// ensure there is no vertical scrolling or empty space. It will only perform
  /// the adjustment when the summernote editor is the loaded page.
  ///
  /// It will also disable vertical scrolling on the webview, so scrolling on
  /// the webview will actually scroll the rest of the page rather than doing
  /// nothing because it is trying to scroll the webview container.
  ///
  /// The default value is true. It is recommended to leave this as true because
  /// it significantly improves the UX.
  final bool autoAdjustHeight;

  /// Sets the editor to dark mode. `null` - switches with system, `false` -
  /// always light, `true` - always dark.
  ///
  /// The default value is null (switches with system).
  final bool? darkMode;

  /// The BoxDecoration to use around the Html editor. By default, the widget
  /// uses a thin, dark, rounded rectangle border around the widget.
  final BoxDecoration decoration;

  /// Specify the file path to your custom html editor code.
  ///
  /// Make sure to set the editor's HTML ID to be 'summernote-2'.
  ///
  /// If you plan to use this on Web, you must add comments in your HTML so the
  /// package can insert the relevant JS code to communicate between Dart and JS.
  /// See the README for more details on this.
  final String? filePath;

  /// Sets the height of the Html editor space. It does not take the toolbar
  /// for the editor into account.
  ///
  /// The default value is 380.
  final double height;

  /// Specifies whether the widget should scroll to reveal the HTML editor when
  /// it is focused or the text content is changed.
  /// See the README examples for the best way to implement this.
  ///
  /// Note: Your editor *must* be in a Scrollable type widget (e.g. ListView,
  /// SingleChildScrollView, etc.) for this to work. Otherwise, nothing will
  /// happen.
  final bool shouldEnsureVisible;

  /// Specifies whether the bottom toolbar for picking an image or copy/pasting
  /// is shown on the widget.
  ///
  /// The default value is true.
  final bool showBottomToolbar;
}

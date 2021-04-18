import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

/// Options that modify the editor and its behavior
class HtmlEditorOptions {
  const HtmlEditorOptions({
    this.autoAdjustHeight = true,
    this.adjustHeightForKeyboard = true,
    this.darkMode,
    this.filePath,
    this.hint,
    this.initialText,
    this.shouldEnsureVisible = false,
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

  /// Specify the file path to your custom html editor code.
  ///
  /// Make sure to set the editor's HTML ID to be 'summernote-2'.
  ///
  /// If you plan to use this on Web, you must add comments in your HTML so the
  /// package can insert the relevant JS code to communicate between Dart and JS.
  /// See the README for more details on this.
  final String? filePath;

  /// Sets the Html editor's hint (text displayed when there is no text in the
  /// editor).
  final String? hint;

  /// The initial text that is be supplied to the Html editor.
  final String? initialText;

  /// Specifies whether the widget should scroll to reveal the HTML editor when
  /// it is focused or the text content is changed.
  /// See the README examples for the best way to implement this.
  ///
  /// Note: Your editor *must* be in a Scrollable type widget (e.g. ListView,
  /// SingleChildScrollView, etc.) for this to work. Otherwise, nothing will
  /// happen.
  final bool shouldEnsureVisible;
}

/// Options that modify the toolbar and its behavior
class HtmlToolbarOptions {
  const HtmlToolbarOptions({
    this.customToolbarButtons = const [],
    this.defaultToolbarButtons = const [
      StyleButtons(),
      FontSettingButtons(),
      FontButtons(),
      ColorButtons(),
      ListButtons(),
      ParagraphButtons(),
      InsertButtons(),
      OtherButtons(),
    ],
    this.toolbarType = ToolbarType.nativeScrollable,
    this.toolbarPosition = ToolbarPosition.aboveEditor,
  });

  /// Allows you to create your own buttons that are added to the end of the
  /// default buttons list
  final List<Widget> customToolbarButtons;

  /// Sets which options are visible in the toolbar for the editor.
  final List<Toolbar> defaultToolbarButtons;

  /// Controls how the toolbar displays. See [ToolbarType] for more details.
  final ToolbarType toolbarType;

  /// Controls where the toolbar is positioned. See [ToolbarPosition] for more details.
  final ToolbarPosition toolbarPosition;
}

/// Other options such as the height of the widget and the decoration surrounding it
class OtherOptions {
  const OtherOptions({
    this.decoration = const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      border: Border.fromBorderSide(
          BorderSide(color: const Color(0xffececec), width: 1)),
    ),
    this.height = 400,
  });

  /// The BoxDecoration to use around the Html editor. By default, the widget
  /// uses a thin, dark, rounded rectangle border around the widget.
  final BoxDecoration decoration;

  /// Sets the height of the Html editor widget. This takes the toolbar into
  /// account (i.e. this sets the height of the entire widget rather than the
  /// editor space)
  ///
  /// The default value is 400.
  final double height;
}
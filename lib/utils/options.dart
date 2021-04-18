import 'package:file_picker/file_picker.dart';
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
    this.imageExtensions,
    this.linkInsertInterceptor,
    this.mediaLinkInsertInterceptor,
    this.mediaUploadInterceptor,
    this.onButtonPressed,
    this.onDropdownChanged,
    this.toolbarType = ToolbarType.nativeScrollable,
    this.toolbarPosition = ToolbarPosition.aboveEditor,
    this.videoExtensions,
  });

  /// Allows you to create your own buttons that are added to the end of the
  /// default buttons list
  final List<Widget> customToolbarButtons;

  /// Sets which options are visible in the toolbar for the editor.
  final List<Toolbar> defaultToolbarButtons;

  /// Allows you to set the allowed extensions when a user inserts an image
  ///
  /// By default any image extension is allowed.
  final List<String>? imageExtensions;

  /// Allows you to intercept any links being inserted into the editor. The
  /// function passes the display text, the URL itself, and whether the
  /// URL should open a new tab.
  ///
  /// Return a bool to tell the plugin if it should continue with its own handler
  /// or if you want to handle the link by yourself.
  /// (true = continue with internal handler, false = do not use internal handler)
  ///
  /// If no interceptor is set, the plugin uses the internal handler.
  final bool Function(String, String, bool)? linkInsertInterceptor;

  /// Allows you to intercept any images/videos inserted as links into the editor.
  /// The function passes the URL of the media inserted.
  ///
  /// Return a bool to tell the plugin if it should continue with its own handler
  /// or if you want to handle the image/video link by yourself.
  /// (true = continue with internal handler, false = do not use internal handler)
  ///
  /// If no interceptor is set, the plugin uses the internal handler.
  final bool Function(String)? mediaLinkInsertInterceptor;

  /// Allows you to intercept any image/video files being inserted into the editor.
  /// The function passes the PlatformFile class, which contains all the file data
  /// including name, size, type, Uint8List bytes, etc.
  ///
  /// Return a bool to tell the plugin if it should continue with its own handler
  /// or if you want to handle the image/video upload by yourself.
  /// (true = continue with internal handler, false = do not use internal handler)
  ///
  /// If no interceptor is set, the plugin uses the internal handler.
  final bool Function(PlatformFile)? mediaUploadInterceptor;

  /// Allows you to intercept any button press. The function passes the ButtonType
  /// enum, which tells you which button was pressed, the current selected status of
  /// the button, and a function to reverse the status (in case you decide to handle
  /// the button press yourself).
  ///
  /// Note: In some cases, the button is never active (e.g. copy/paste buttons)
  /// so null will be returned for both the selected status and the function.
  ///
  /// Return a bool to tell the plugin if it should continue with its own handler
  /// or if you want to handle the button press by yourself.
  /// (true = continue with internal handler, false = do not use internal handler)
  ///
  /// If no interceptor is set, the plugin uses the internal handler.
  final bool Function(ButtonType, bool?, void Function()?)? onButtonPressed;

  /// Allows you to intercept any dropdown changes. The function passes the
  /// DropdownType enum, which tells you which dropdown was changed,
  /// the changed value to indicate what the dropdown was changed to, and the
  /// function to update the changed value (in case you decide to handle the
  /// dropdown change yourself).
  ///
  /// Return a bool to tell the plugin if it should continue with its own handler
  /// or if you want to handle the dropdown change by yourself.
  /// (true = continue with internal handler, false = do not use internal handler)
  ///
  /// If no interceptor is set, the plugin uses the internal handler.
  final bool Function(DropdownType, dynamic, void Function(dynamic))? onDropdownChanged;

  /// Controls how the toolbar displays. See [ToolbarType] for more details.
  ///
  /// By default the toolbar is rendered as a scrollable one-line list.
  final ToolbarType toolbarType;

  /// Controls where the toolbar is positioned. See [ToolbarPosition] for more details.
  ///
  /// By default the toolbar is above the editor.
  final ToolbarPosition toolbarPosition;

  /// Allows you to set the allowed extensions when a user inserts a video.
  ///
  /// By default any video extension is allowed.
  final List<String>? videoExtensions;
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
import 'dart:async';
import 'dart:collection';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

/// Options that modify the editor and its behavior
class HtmlEditorOptions {
  const HtmlEditorOptions({
    this.autoAdjustHeight = true,
    this.androidUseHybridComposition = true,
    this.adjustHeightForKeyboard = true,
    this.characterLimit,
    this.customOptions = '',
    this.darkMode,
    this.disabled = false,
    this.filePath,
    this.hint,
    this.initialText,
    this.inputType = HtmlInputType.text,
    this.mobileContextMenu,
    this.mobileLongPressDuration,
    this.mobileInitialScripts,
    this.webInitialScripts,
    this.shouldEnsureVisible = false,
    this.spellCheck = false,
  });

  /// The editor will automatically adjust its height when the keyboard is active
  /// to prevent the keyboard overlapping the editor.
  ///
  /// The default value is true. It is recommended to leave this as true because
  /// it significantly improves the UX.
  final bool adjustHeightForKeyboard;

  /// ALlows devs to set hybrid composition off in case they would like to
  /// prioritize animation smoothness over text input experience.
  ///
  /// The recommended value is `true`.
  final bool androidUseHybridComposition;

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

  /// Adds a character limit to the editor.
  ///
  /// NOTE: ONLY WORKS ON iOS AND WEB PLATFORMS!!
  final int? characterLimit;

  /// Set custom options for the summernote editor by using their syntax.
  ///
  /// Please ensure your syntax is correct (and add a comma at the end of your
  /// string!) otherwise the editor may not load.
  final String customOptions;

  /// Sets the editor to dark mode. `null` - switches with system, `false` -
  /// always light, `true` - always dark.
  ///
  /// The default value is null (switches with system).
  final bool? darkMode;

  /// Disable the editor immediately after startup. You can re-enable the editor
  /// by calling [controller.enable()].
  final bool disabled;

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

  /// Changes the display of the virtual keyboard on mobile devices.
  ///
  /// See [HtmlInputType] for the supported modes.
  ///
  /// The default value is [HtmlInputType.text] (the standard virtual keyboard)
  final HtmlInputType inputType;

  /// Customize the context menu for selected text on mobile
  final ContextMenu? mobileContextMenu;

  /// Set the duration until a long-press is recognized.
  ///
  /// The default value is 500ms.
  final Duration? mobileLongPressDuration;

  /// Initial JS to inject into the editor.
  final UnmodifiableListView<UserScript>? mobileInitialScripts;

  /// Initial JS to add to the editor. These can be called at any time using
  /// [controller.evaluateJavascriptWeb]
  final UnmodifiableListView<WebScript>? webInitialScripts;

  /// Specifies whether the widget should scroll to reveal the HTML editor when
  /// it is focused or the text content is changed.
  /// See the README examples for the best way to implement this.
  ///
  /// Note: Your editor *must* be in a Scrollable type widget (e.g. ListView,
  /// SingleChildScrollView, etc.) for this to work. Otherwise, nothing will
  /// happen.
  final bool shouldEnsureVisible;

  /// Specify whether or not the editor should spellcheck its contents.
  ///
  /// Default value is false.
  final bool spellCheck;
}

/// Options that modify the toolbar and its behavior
class HtmlToolbarOptions {
  const HtmlToolbarOptions({
    this.audioExtensions,
    this.customToolbarButtons = const [],
    this.customToolbarInsertionIndices = const [],
    this.defaultToolbarButtons = const [
      StyleButtons(),
      FontSettingButtons(fontSizeUnit: false),
      FontButtons(clearAll: false),
      ColorButtons(),
      ListButtons(listStyles: false),
      ParagraphButtons(
          textDirection: false, lineHeight: false, caseConverter: false),
      InsertButtons(
          video: false,
          audio: false,
          table: false,
          hr: false,
          otherFile: false),
    ],
    this.otherFileExtensions,
    this.imageExtensions,
    this.initiallyExpanded = false,
    this.linkInsertInterceptor,
    this.mediaLinkInsertInterceptor,
    this.mediaUploadInterceptor,
    this.onButtonPressed,
    this.onDropdownChanged,
    this.onOtherFileLinkInsert,
    this.onOtherFileUpload,
    this.toolbarType = ToolbarType.nativeScrollable,
    this.toolbarPosition = ToolbarPosition.aboveEditor,
    this.videoExtensions,
    this.dropdownElevation = 8,
    this.dropdownIcon,
    this.dropdownIconColor,
    this.dropdownIconSize = 24,
    this.dropdownItemHeight = kMinInteractiveDimension,
    this.dropdownFocusColor,
    this.dropdownBackgroundColor,
    this.dropdownMenuDirection,
    this.dropdownMenuMaxHeight,
    this.dropdownBoxDecoration,
    this.buttonColor,
    this.buttonSelectedColor,
    this.buttonFillColor,
    this.buttonFocusColor,
    this.buttonHighlightColor,
    this.buttonHoverColor,
    this.buttonSplashColor,
    this.buttonBorderColor,
    this.buttonSelectedBorderColor,
    this.buttonBorderRadius,
    this.buttonBorderWidth,
    this.renderBorder = false,
    this.textStyle,
    this.separatorWidget =
        const VerticalDivider(indent: 2, endIndent: 2, color: Colors.grey),
    this.renderSeparatorWidget = true,
    this.toolbarItemHeight = 36,
    this.gridViewHorizontalSpacing = 5,
    this.gridViewVerticalSpacing = 5,
    this.allowImagePicking = true,
  });

  /// Allows you to set the allowed extensions when a user inserts an audio file
  ///
  /// By default any audio extension is allowed.
  final List<String>? audioExtensions;

  /// Allows you to create your own buttons that are added to the end of the
  /// default buttons list
  final List<Widget> customToolbarButtons;

  /// Allows you to set where each custom toolbar button is inserted into the
  /// toolbar buttons.
  ///
  /// Notes: 1) This list should have the same length as the [customToolbarButtons]
  ///
  /// 2) If any indices > [defaultToolbarButtons.length] then the plugin will
  /// automatically account for this and insert the buttons at the end of the
  /// [defaultToolbarButtons]
  ///
  /// 3) If any indices < 0 then the plugin will automatically account for this
  /// and insert the buttons at the beginning of the [defaultToolbarButtons]
  final List<int> customToolbarInsertionIndices;

  /// Sets which options are visible in the toolbar for the editor.
  final List<Toolbar> defaultToolbarButtons;

  /// Allows you to set the allowed extensions when a user inserts an image
  ///
  /// By default any image extension is allowed.
  final List<String>? imageExtensions;

  /// Allows you to set whether the toolbar starts out expanded (in gridview)
  /// or contracted (in scrollview).
  ///
  /// By default it starts out contracted.
  ///
  /// This option only works when you have set [toolbarType] to
  /// [ToolbarType.nativeExpandable].
  final bool initiallyExpanded;

  /// Allows you to intercept any links being inserted into the editor. The
  /// function passes the display text, the URL itself, and whether the
  /// URL should open a new tab.
  ///
  /// Return a bool to tell the plugin if it should continue with its own handler
  /// or if you want to handle the link by yourself.
  /// (true = continue with internal handler, false = do not use internal handler)
  ///
  /// If no interceptor is set, the plugin uses the internal handler.
  final FutureOr<bool> Function(String, String, bool)? linkInsertInterceptor;

  /// Allows you to intercept any image/video/audio inserted as a link into the editor.
  /// The function passes the URL of the media inserted.
  ///
  /// Return a bool to tell the plugin if it should continue with its own handler
  /// or if you want to handle the image/video link by yourself.
  /// (true = continue with internal handler, false = do not use internal handler)
  ///
  /// If no interceptor is set, the plugin uses the internal handler.
  final FutureOr<bool> Function(String, InsertFileType)?
      mediaLinkInsertInterceptor;

  /// Allows you to intercept any image/video/audio files being inserted into the editor.
  /// The function passes the PlatformFile class, which contains all the file data
  /// including name, size, type, Uint8List bytes, etc.
  ///
  /// Return a bool to tell the plugin if it should continue with its own handler
  /// or if you want to handle the image/video/audio upload by yourself.
  /// (true = continue with internal handler, false = do not use internal handler)
  ///
  /// If no interceptor is set, the plugin uses the internal handler.
  final FutureOr<bool> Function(PlatformFile, InsertFileType)?
      mediaUploadInterceptor;

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
  final FutureOr<bool> Function(ButtonType, bool?, Function?)? onButtonPressed;

  /// Allows you to intercept any dropdown changes. The function passes the
  /// DropdownType enum, which tells you which dropdown was changed,
  /// the changed value to indicate what the dropdown was changed to, and the
  /// function to update the changed value (in case you decide to handle the
  /// dropdown change yourself). The function is null in some cases because
  /// the dropdown does not update its value.
  ///
  /// Return a bool to tell the plugin if it should continue with its own handler
  /// or if you want to handle the dropdown change by yourself.
  /// (true = continue with internal handler, false = do not use internal handler)
  ///
  /// If no interceptor is set, the plugin uses the internal handler.
  final FutureOr<bool> Function(DropdownType, dynamic, void Function(dynamic)?)?
      onDropdownChanged;

  /// Called when a link is inserted for a file using the "other file" button.
  ///
  /// The package does not have a built in handler for these files, so you should
  /// provide this callback when using the button.
  ///
  /// The function passes the URL of the file inserted.
  final void Function(String)? onOtherFileLinkInsert;

  /// Called when a file is uploaded using the "other file" button.
  ///
  /// The package does not have a built in handler for these files, so if you use
  /// the button you should provide this callback.
  ///
  /// The function passes the PlatformFile class, which contains all the file data
  /// including name, size, type, Uint8List bytes, etc.
  final void Function(PlatformFile)? onOtherFileUpload;

  /// Allows you to set the allowed extensions when a user inserts a file other
  /// than image/audio/video
  ///
  /// By default any other extension is allowed.
  final List<String>? otherFileExtensions;

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

  /// Styling options for the toolbar:

  /// Determines whether a border is rendered around all toolbar widgets
  ///
  /// The default value is false. True is recommended for [ToolbarType.nativeGrid].
  final bool renderBorder;

  /// Sets the text style for all toolbar widgets
  final TextStyle? textStyle;

  /// Sets the separator widget between toolbar sections. This widget is only
  /// used in [ToolbarType.nativeScrollable].
  ///
  /// The default widget is [VerticalDivider(indent: 2, endIndent: 2, color: Colors.grey)]
  final Widget separatorWidget;

  /// Determines whether the separator widget is rendered
  ///
  /// The default value is true
  final bool renderSeparatorWidget;

  /// Sets the height of the toolbar items
  ///
  /// Button width is affected by this parameter, however dropdown widths are
  /// not affected. The plugin will maintain a square shape for all buttons.
  ///
  /// The default value is 36
  final double toolbarItemHeight;

  /// Sets the vertical spacing between rows when using [ToolbarType.nativeGrid]
  ///
  /// The default value is 5
  final double gridViewVerticalSpacing;

  /// Sets the horizontal spacing between items when using [ToolbarType.nativeGrid]
  ///
  /// The default value is 5
  final double gridViewHorizontalSpacing;

  /// Styling options that only apply to dropdowns:
  /// (See the [DropdownButton] class for more information)

  final int dropdownElevation;
  final Widget? dropdownIcon;
  final Color? dropdownIconColor;
  final double dropdownIconSize;
  final double dropdownItemHeight;
  final Color? dropdownFocusColor;
  final Color? dropdownBackgroundColor;

  /// Set the menu opening direction for the dropdown. Only useful when using
  /// [ToolbarPosition.custom] since the toolbar otherwise automatically
  /// determines the correct direction.
  final DropdownMenuDirection? dropdownMenuDirection;
  final double? dropdownMenuMaxHeight;
  final BoxDecoration? dropdownBoxDecoration;

  /// Styling options that only apply to the buttons:
  /// (See the [ToggleButtons] class for more information)

  final Color? buttonColor;
  final Color? buttonSelectedColor;
  final Color? buttonFillColor;
  final Color? buttonFocusColor;
  final Color? buttonHighlightColor;
  final Color? buttonHoverColor;
  final Color? buttonSplashColor;
  final Color? buttonBorderColor;
  final Color? buttonSelectedBorderColor;
  final BorderRadius? buttonBorderRadius;
  final double? buttonBorderWidth;

  /// Allow the user to choose an image from their device when image selection
  /// is enabled. Inserting images via URL will still be possible if this is false.
  final bool allowImagePicking;
}

/// Other options such as the height of the widget and the decoration surrounding it
class OtherOptions {
  const OtherOptions({
    this.decoration = const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      border:
          Border.fromBorderSide(BorderSide(color: Color(0xffececec), width: 1)),
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

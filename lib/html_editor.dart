library html_editor;

import 'package:html_editor_enhanced/src/html_editor_controller_unsupported.dart'
    if (dart.library.html) 'package:html_editor_enhanced/src/html_editor_controller_web.dart'
    if (dart.library.io) 'package:html_editor_enhanced/src/html_editor_controller_mobile.dart';

export 'package:html_editor_enhanced/utils/callbacks.dart';
export 'package:html_editor_enhanced/utils/toolbar.dart';
export 'package:html_editor_enhanced/utils/plugins.dart';
export 'package:html_editor_enhanced/utils/file_upload_model.dart';
export 'package:html_editor_enhanced/utils/options.dart';

export 'package:html_editor_enhanced/src/html_editor_unsupported.dart'
    if (dart.library.html) 'package:html_editor_enhanced/src/html_editor_web.dart'
    if (dart.library.io) 'package:html_editor_enhanced/src/html_editor_mobile.dart';

export 'package:html_editor_enhanced/src/html_editor_controller_unsupported.dart'
    if (dart.library.html) 'package:html_editor_enhanced/src/html_editor_controller_web.dart'
    if (dart.library.io) 'package:html_editor_enhanced/src/html_editor_controller_mobile.dart';

/// Global variable used to get the [InAppWebViewController] of the Html editor
Map<HtmlEditorController, dynamic> controllerMap = {};

/// Global variable used to get the function to update the toolbar widget
void Function(Map<String, dynamic>)? updateToolbar;

/// Manages the notification type for a notification displayed at the bottom of
/// the editor
enum NotificationType { info, warning, success, danger, plaintext }

/// Manages the way the toolbar displays:
/// [nativeGrid] - a grid view (non scrollable) of all the buttons
/// [nativeScrollable] - a scrollable one-line view of all the buttons
/// [summernote] - uses the default summernote buttons (no native controls and
/// reduced feature support)
enum ToolbarType { nativeGrid, nativeScrollable, summernote }

/// Manages the position of the toolbar, whether above or below the editor
///
/// Note: This is ignored when [ToolbarType.summernote] is set.
enum ToolbarPosition { aboveEditor, belowEditor }

enum ButtonType { style, bold, italic, underline, clearFormatting, strikethrough,
    superscript, subscript, foregroundColor, highlightColor, ul, ol, alignLeft,
    alignCenter, alignRight, alignJustify, increaseIndent, decreaseIndent, link,
    picture, video, table, hr, fullscreen, codeview, undo, redo, help, copy, paste }

enum DropdownType { style, fontSize, fontSizeUnit, listStyles, lineHeight }

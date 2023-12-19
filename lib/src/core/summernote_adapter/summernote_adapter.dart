import '../../../utils/callbacks.dart';

abstract class SummernoteAdapter {
  /// A unique key for editor.
  ///
  /// For web this is the id of the IFrameElement rendering the editor. It set to
  /// [HtmlElementView.id].
  ///
  /// For mobile (using InAppWebView) this is the key given to [VisibilityDetector] wrapping the
  /// editor.
  final String key;

  /// The javascript (jQuery) selector of the summernote editor.
  final String divSelector;

  /// The callbacks to be set for the editor.
  final Callbacks? callbacks;

  /// The height of the editor.
  final int height;

  /// Build string for [Callbacks.onBeforeCommand].
  String get onBeforeCommandCallback;

  /// Build string for [Callbacks.onChangeCodeview].
  String get onChangeCodeviewCallback;

  /// Build string for [Callbacks.onDialogShown].
  String get onDialogShownCallback;

  /// Build string for [Callbacks.onEnter].
  String get onEnterCallback;

  /// Build string for [Callbacks.onFocus].
  String get onFocusCallback;

  /// Build string for [Callbacks.onBlur].
  String get onBlurCallback;

  /// Build string for [Callbacks.onBlurCodeview].
  String get onBlurCodeviewCallback;

  /// Build string for [Callbacks.onImageLinkInsert].
  String get onImageLinkInsertCallback;

  /// Build string for [Callbacks.onImageUpload].
  String get onImageUploadCallback;

  /// Build string for [Callbacks.onImageUploadError].
  String get onImageUploadErrorCallback;

  /// Build string for [Callbacks.onKeyUp].
  String get onKeyUpCallback;

  /// Build string for [Callbacks.onKeyDown].
  String get onKeyDownCallback;

  /// Build string for [Callbacks.onMouseUp].
  String get onMouseUpCallback;

  /// Build string for [Callbacks.onMouseDown].
  String get onMouseDownCallback;

  /// Build string for [Callbacks.onPaste].
  String get onPasteCallback;

  /// Build string for [Callbacks.onScroll].
  String get onScrollCallback;

  const SummernoteAdapter({
    required this.key,
    this.divSelector = "\$('#summernote-2')",
    this.callbacks,
    this.height = 30,
  });

  String onEventCallback({required String eventName, required String callback}) =>
      "$eventName: $callback";

  /// Builds a JavaScript code which will be used to send a message to the parent window (for web) or the
  /// webview containing the editor.
  String onEventHandler({required String handler, required String eventName}) =>
      "$divSelector.on('$eventName', $handler);";

  /// Build a javascript function.
  ///
  /// [args] are the arguments of the function.
  /// [body] is the body of the function.
  String javaScriptFunction({List<String> args = const [], required String body}) => '''
    function(${args.join(', ')}) {
      $body
    }
  ''';
}

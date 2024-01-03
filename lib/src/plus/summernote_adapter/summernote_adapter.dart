import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_plus/src/plus/core/editor_callbacks.dart';

import 'summernote_adapter_inappwebview.dart';
import 'summernote_adapter_web.dart';
import '../core/enums.dart';

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
  final String summernoteSelector;

  /// The resize mode of the editor.
  final ResizeMode resizeMode;

  /// If the [EditorCallbacks.onFocus] should be enabled.
  final bool enableOnFocus;

  /// If the [EditorCallbacks.onBlur] should be enabled.
  final bool enableOnBlur;

  /// If the [EditorCallbacks.onImageUpload] should be enabled.
  final bool enableOnImageUpload;

  /// If the [EditorCallbacks.onImageUploadError] should be enabled.
  final bool enableOnImageUploadError;

  /// Build string for [EditorCallbacks.onInit] callback.
  String get onInitCallback => summernoteCallback(
        event: EditorCallbacks.onInit,
        body: messageHandler(event: EditorCallbacks.onInit),
      );

  /// Build string for [EditorCallbacks.onChange] callback.
  String get onChangeCallback => summernoteCallback(
        event: EditorCallbacks.onChange,
        args: const ["contents", "\$editable"],
        body: messageHandler(event: EditorCallbacks.onChange, payload: "contents"),
      );

  /// Build string for [EditorCallbacks.onChangeCodeview] callback.
  ///
  /// This callback is called when the content has changed while in codeview mode.
  String get onChangeCodeviewCallback => summernoteCallback(
        event: EditorCallbacks.onChangeCodeview,
        args: const ["contents", "\$editable"],
        body: messageHandler(event: EditorCallbacks.onChangeCodeview, payload: "contents"),
      );

  /// Build string for [EditorCallbacks.onFocus] callback.
  String get onFocusCallback => summernoteCallback(
        event: EditorCallbacks.onFocus,
        args: const [],
        body: messageHandler(event: EditorCallbacks.onFocus),
      );

  /// Build string for [EditorCallbacks.onBlur] callback.
  String get onBlurCallback => summernoteCallback(
        event: EditorCallbacks.onBlur,
        args: const [],
        body: messageHandler(event: EditorCallbacks.onBlur),
      );

  /// Build string for [EditorCallbacks.onImageUpload] callback.
  String get onImageUploadCallback => summernoteCallback(
        event: EditorCallbacks.onImageUpload,
        args: const ["files"],
        body: "uploadFile(files[0])",
      );

  /// Build string for [EditorCallbacks.onImageUploadError] callback.
  String get onImageUploadErrorCallback => summernoteCallback(
        event: EditorCallbacks.onImageUploadError,
        args: const ["file", "error"],
        body: "uploadError(file, error)",
      );

  /// Build a string which contains javascript specific to the current platform.
  ///
  ///
  /// On web we need some extra code to handle communication between the app and summernote editor.
  String get platformSpecificJavascript;

  /// Selector for the html input used by summernote.
  String get editorSelector => "\$('div.note-editable')";

  /// Custom CSS used to style the editor.
  String css({ColorScheme? colorScheme}) {
    const requiredCss = '''
.note-statusbar {
  display: none;
}
''';
    if (colorScheme == null) return requiredCss;

    final surface = colorScheme.surface.hex;
    final onSurface = colorScheme.onSurface.hex;
    final surfaceVariant = colorScheme.surfaceVariant.hex;
    final onSurfaceVariant = colorScheme.onSurfaceVariant.hex;

    return '''
  $requiredCss
 
  .note-editing-area, .note-status-output, .note-codable, .CodeMirror, .CodeMirror-gutter, .note-modal-content, .note-input, .note-editable {
    background: #$surface !important;
  }
  .panel-heading, .note-toolbar, .note-statusbar {
    background: #$surfaceVariant !important;
  }
  input, select, textarea, .CodeMirror, .note-editable, [class^="note-icon-"], .caseConverter-toggle,
  button > b, button > code, button > var, button > kbd, button > samp, button > small, button > ins, button > del, button > p, button > i {
    color: #$onSurface !important;
  }
  textarea:focus, input:focus, span, label, .note-status-output {
    color: #$onSurface !important;
  }
  .note-icon-font {
    color: #$onSurfaceVariant !important;
  }
  .note-btn:not(.note-color-btn) {
    background-color: #$surface !important;
  }
  .note-btn:focus,
  .note-btn:active,
  .note-btn.active {
    background-color: #$surfaceVariant !important;
  }
  ''';
  }

  const SummernoteAdapter({
    required this.key,
    this.summernoteSelector = "\$('#summernote-2')",
    this.resizeMode = ResizeMode.resizeToParent,
    this.enableOnFocus = false,
    this.enableOnBlur = false,
    this.enableOnImageUpload = false,
    this.enableOnImageUploadError = false,
  });

  factory SummernoteAdapter.web({
    required String key,
    String summernoteSelector = "\$('#summernote-2')",
    ResizeMode resizeMode = ResizeMode.resizeToParent,
    bool enableOnFocus = false,
    bool enableOnBlur = false,
    bool enableOnImageUpload = false,
    bool enableOnImageUploadError = false,
  }) =>
      SummernoteAdapterWeb(
        key: key,
        summernoteSelector: summernoteSelector,
        resizeMode: resizeMode,
        enableOnFocus: enableOnFocus,
        enableOnBlur: enableOnBlur,
        enableOnImageUpload: enableOnImageUpload,
        enableOnImageUploadError: enableOnImageUploadError,
      );

  factory SummernoteAdapter.inAppWebView({
    required String key,
    String summernoteSelector = "\$('#summernote-2')",
    ResizeMode resizeMode = ResizeMode.resizeToParent,
    bool enableOnFocus = false,
    bool enableOnBlur = false,
    bool enableOnImageUpload = false,
    bool enableOnImageUploadError = false,
  }) =>
      SummernoteAdapterInappWebView(
        key: key,
        summernoteSelector: summernoteSelector,
        resizeMode: resizeMode,
        enableOnFocus: enableOnFocus,
        enableOnBlur: enableOnBlur,
        enableOnImageUpload: enableOnImageUpload,
        enableOnImageUploadError: enableOnImageUploadError,
      );

  /// Initialise the summernote editor.
  ///
  /// [hintText] is the placeholder text.
  /// [summernoteToolbar] is the string containing all the data about the toolbar.
  /// [spellCheck] is whether to enable spell check.
  /// https://summernote.org/deep-dive/#disable-spellchecking
  /// [maximumFileSize] is the maximum file size allowed to be uploaded.
  /// [customOptions] is the string containing all the custom options injected by the developer
  /// using this package.
  /// [summernoteCallbacks] is the list of callbacks to be set for the editor.
  String summernoteInit({
    String hintText = "",
    String summernoteToolbar = "[]",
    bool spellCheck = false,
    int maximumFileSize = 10485760,
    String customOptions = "",
    List<String> summernoteCallbacks = const [],
  }) =>
      '''

function uploadFile(file) {
  const reader = new FileReader();
  let base64 = "";
  reader.onload = function(_) {
    base64 = reader.result;
    const fileObject = ${objectFromFile(fileNode: "file")};
    ${messageHandler(
        event: EditorCallbacks.onImageUpload,
        payload: "JSON.stringify(fileObject)",
      )}
  };
  reader.onerror = function (_) {
    const fileObject = ${objectFromFile(fileNode: "file")};
    const fileObjectAsString = JSON.stringify(fileObject);
    ${messageHandler(
        event: EditorCallbacks.onImageUploadError,
        payload: "JSON.stringify({'file': fileObjectAsString, 'error': 'An error occurred!'})",
      )}
  };
  reader.readAsDataURL(file);
}

function uploadError(file, error) {
  if (typeof file === 'string') {
    ${messageHandler(
        event: EditorCallbacks.onImageUploadError,
        payload: "JSON.stringify({'file': file, 'error': error})",
      )}
  } else {
    const fileObject = ${objectFromFile(fileNode: "file", hasBase64: false)};
    const fileObjectAsString = JSON.stringify(fileObject);
    ${messageHandler(
        event: EditorCallbacks.onImageUploadError,
        payload: "JSON.stringify({'file': fileObjectAsString, 'error': error})",
      )}
  }
}

function createLink(payload) {
  const data = JSON.parse(payload);
  const text = data["text"];
  const url = data["url"];
  ${callSummernoteMethod(
        method: 'createLink',
        payload: '{text: text, url: url, isNewWindow: data["isNewWindow"]}',
      )}
}

function insertImage(payload) {
  logDebug("Inserting image: " + payload);
  const data = JSON.parse(payload);
  const filename = data["filename"];
  const url = data["url"];
  ${callSummernoteMethod(method: 'insertImage', payload: 'url, filename')}
}


function setCursorToEnd() {
    ${callSummernoteMethod(
        method: "setLastRange",
        payload: '\$.summernote.range.createFromNodeAfter($editorSelector[0]).select()',
      )}
}

function setHtml(value) {
  const currentValue = ${callSummernoteMethod(method: "code")}
  logDebug("Current value: " + currentValue);
  if (value == currentValue) {
    return;
  }
  logDebug("Setting value: " + value);
  ${callSummernoteMethod(method: "code", payload: 'value')}
  setCursorToEnd();
}

function logDebug(message) {
  if ($kDebugMode) console.log(message);
}
  
function resizeToParent() {
  logDebug("Resizing to parent");
  ${editorHeight(height: "window.innerHeight")}
  ${editorWidth(width: "window.innerWidth")}
}
  
$summernoteSelector.summernote({
  ${hintText.trim().isNotEmpty ? "placeholder: '$hintText'," : ""}
  tabsize: 2,
  toolbar: $summernoteToolbar,
  disableGrammar: false,
  spellCheck: $spellCheck,
  maximumFileSize: $maximumFileSize,
  ${customOptions.trim().isNotEmpty ? "$customOptions," : ""}
  callbacks: {
    ${summernoteCallbacks.join(",\n")}
  }
});
  
$platformSpecificJavascript
  
if (${resizeMode == ResizeMode.resizeToParent}) {
  resizeToParent();
  addEventListener("resize", (event) => resizeToParent());
}



  
logDebug("Summernote initialised");
''';

  /// Builds a JavaScript code which will be used to send a message to the Dart side.
  ///
  /// [payload] is an optional payload.
  String messageHandler({required EditorCallbacks event, String? payload});

  /// Build a JS function to get/set summernote's `outerHeight`.
  String editorHeight({String height = ""}) => "$editorSelector.outerHeight($height);";

  /// Build a JS function to get/set summernote's `width`.
  String editorWidth({String? width = ""}) => "$editorSelector.width($width);";

  /// Build a JS function to call a summernote editor's function.
  ///
  /// [method] is the name of the function to call.
  /// [payload] is the value passed to the function.
  /// [wrapMethod] is whether to wrap the method in quotes.
  String callSummernoteMethod({
    required String method,
    String? payload,
    bool wrapMethod = true,
  }) {
    final effectiveMethod = wrapMethod ? "'$method'" : method;
    final args = [effectiveMethod, if (payload != null) payload];
    return "$summernoteSelector.summernote(${args.join(",")});";
  }

  /// Wrap a string in quotes.
  ///
  /// On mobile platform retrieving JSON values needs to be done with quotes.
  String wrapInQuotes({required String value, bool wrap = true}) => wrap ? "'$value'" : value;

  List<String> summernoteCallbacks({
    int? characterLimit,
  }) =>
      [
        onInitCallback,
        onChangeCallback,
        onChangeCodeviewCallback,
        if (enableOnFocus) onFocusCallback,
        if (enableOnBlur) onBlurCallback,
        if (enableOnImageUpload) onImageUploadCallback,
        if (enableOnImageUploadError) onImageUploadErrorCallback,
      ];

  /// Build the function called for `onKeydown` event which emits `characterCount`.
  String onCharacterCountCallbackFunction({
    required String messageHandler,
    int? characterLimit,
  }) =>
      javaScriptCallbackFunction(
        args: const ["e"],
        body: '''
          var chars = \$(".note-editable").text();
          var totalChars = chars.length.toString();
          ${(characterLimit != null) ? _characterCountAllowedKeys(characterLimit) : ""}
          $messageHandler
        ''',
      );

  String _characterCountAllowedKeys(int characterLimit) => '''
    allowedKeys = (
      e.which === 8 ||  /* BACKSPACE */
      e.which === 35 || /* END */
      e.which === 36 || /* HOME */
      e.which === 37 || /* LEFT */
      e.which === 38 || /* UP */
      e.which === 39 || /* RIGHT*/
      e.which === 40 || /* DOWN */
      e.which === 46 || /* DEL*/
      e.ctrlKey === true && e.which === 65 || /* CTRL + A */
      e.ctrlKey === true && e.which === 88 || /* CTRL + X */
      e.ctrlKey === true && e.which === 67 || /* CTRL + C */
      e.ctrlKey === true && e.which === 86 || /* CTRL + V */
      e.ctrlKey === true && e.which === 90    /* CTRL + Z */
    );
    if (!allowedKeys && \$(e.target).text().length >= $characterLimit) {
      e.preventDefault();
    }
''';

  String onSelectionChangeFunction({required String messageHandler}) => '''
    function onSelectionChange() {
          let {anchorNode, anchorOffset, focusNode, focusOffset} = document.getSelection();
          var isBold = false;
          var isItalic = false;
          var isUnderline = false;
          var isStrikethrough = false;
          var isSuperscript = false;
          var isSubscript = false;
          var isUL = false;
          var isOL = false;
          var isLeft = false;
          var isRight = false;
          var isCenter = false;
          var isFull = false;
          var parent;
          var fontName;
          var fontSize = 16;
          var foreColor = "000000";
          var backColor = "FFFF00";
          var focusNode2 = \$(window.getSelection().focusNode);
          var parentList = focusNode2.closest("div.note-editable ol, div.note-editable ul");
          var parentListType = parentList.css('list-style-type');
          var lineHeight = \$(focusNode.parentNode).css('line-height');
          var direction = \$(focusNode.parentNode).css('direction');
          if (document.queryCommandState) {
            isBold = document.queryCommandState('bold');
            isItalic = document.queryCommandState('italic');
            isUnderline = document.queryCommandState('underline');
            isStrikethrough = document.queryCommandState('strikeThrough');
            isSuperscript = document.queryCommandState('superscript');
            isSubscript = document.queryCommandState('subscript');
            isUL = document.queryCommandState('insertUnorderedList');
            isOL = document.queryCommandState('insertOrderedList');
            isLeft = document.queryCommandState('justifyLeft');
            isRight = document.queryCommandState('justifyRight');
            isCenter = document.queryCommandState('justifyCenter');
            isFull = document.queryCommandState('justifyFull');
          }
          if (document.queryCommandValue) {
            parent = document.queryCommandValue('formatBlock');
            fontSize = document.queryCommandValue('fontSize');
            foreColor = document.queryCommandValue('foreColor');
            backColor = document.queryCommandValue('hiliteColor');
            fontName = document.queryCommandValue('fontName');
          }
          var message = {
            ${kIsWeb ? "'view': $key," : ""}
            ${kIsWeb ? "'type': 'toDart: updateToolbar'," : ""},
            'style': parent,
            'fontName': fontName,
            'fontSize': fontSize,
            'font': [isBold, isItalic, isUnderline],
            'miscFont': [isStrikethrough, isSuperscript, isSubscript],
            'color': [foreColor, backColor],
            'paragraph': [isUL, isOL],
            'listStyle': parentListType,
            'align': [isLeft, isCenter, isRight, isFull],
            'lineHeight': lineHeight,
            'direction': direction,
          };
          $messageHandler
        }
''';

  /// Build a JS callback for the summernote editor.
  String summernoteCallback({
    required EditorCallbacks event,
    List<String> args = const [],
    String body = "",
  }) =>
      "${event.callback}: ${javaScriptCallbackFunction(args: args, body: body)}";

  /// Build a callable javascript function.
  String javascriptFunction({required String name, String? arg}) => "$name(${arg ?? ""});";

  /// Build a javascript function.
  ///
  /// [args] are the arguments of the function.
  /// [body] is the body of the function.
  String javaScriptCallbackFunction({List<String> args = const [], required String body}) => '''
    function(${args.join(', ')}) {
      $body
    }
  ''';

  /// Build a JS object for file upload.
  String objectFromFile({required String fileNode, bool hasBase64 = true}) => '''
    {
      'lastModified': $fileNode.lastModified,
      'lastModifiedDate': $fileNode.lastModifiedDate,
      'name': $fileNode.name,
      'size': $fileNode.size,
      'mimeType': $fileNode.type,
      ${hasBase64 ? "'base64': base64," : ""}
    };
  ''';
}

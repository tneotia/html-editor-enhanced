import 'summernote_adapter.dart';

class SummernoteAdapterInappWebView extends SummernoteAdapter {
  @override
  String get onBeforeCommandCallback => onEventHandler(
        eventName: "summernote.before.command",
        handler: javaScriptFunction(
          args: ["_", "contents"],
          body: _callHandler(functionName: "onBeforeCommand", extra: "contents"),
        ),
      );

  @override
  String get onBlurCallback => onEventHandler(
        eventName: "summernote.blur",
        handler: javaScriptFunction(
          body: _callHandler(functionName: "onBlur", extra: "'fired'"),
        ),
      );

  @override
  String get onBlurCodeviewCallback => onEventHandler(
        eventName: "summernote.blur.codeview",
        handler: javaScriptFunction(
          body: _callHandler(functionName: "onBlurCodeview", extra: "'fired'"),
        ),
      );

  @override
  String get onChangeCodeviewCallback => onEventHandler(
        eventName: "summernote.change.codeview",
        handler: javaScriptFunction(
          args: const ["_", "contents"],
          body: _callHandler(functionName: "onChangeCodeview", extra: "contents"),
        ),
      );

  @override
  String get onDialogShownCallback => onEventHandler(
        eventName: "summernote.dialog.shown",
        handler: javaScriptFunction(
          body: _callHandler(functionName: "onDialogShown", extra: "'fired'"),
        ),
      );

  @override
  String get onEnterCallback => onEventHandler(
        eventName: "summernote.enter",
        handler: javaScriptFunction(
          body: _callHandler(functionName: "onEnter", extra: "'fired'"),
        ),
      );

  @override
  String get onFocusCallback => onEventHandler(
        eventName: "summernote.focus",
        handler: javaScriptFunction(
          body: _callHandler(functionName: "onFocus", extra: "'fired'"),
        ),
      );

  @override
  String get onImageLinkInsertCallback => onEventCallback(
        eventName: "onImageLinkInsert",
        callback: javaScriptFunction(
          args: const ["url"],
          body: _callHandler(functionName: "onImageLinkInsert", extra: "url"),
        ),
      );

  @override
  String get onImageUploadCallback => onEventCallback(
        eventName: "onImageUpload",
        callback: javaScriptFunction(
          args: const ["files"],
          body: _onImageUploadCallbackBody,
        ),
      );

  String get _onImageUploadCallbackBody => '''
            const reader = new FileReader();
            let base64 = "<an error occurred>";
            reader.onload = function (_) {
              base64 = reader.result;
              const newObject = {
                 'lastModified': files[0].lastModified,
                 'lastModifiedDate': files[0].lastModifiedDate,
                 'name': files[0].name,
                 'size': files[0].size,
                 'type': files[0].type,
                 'base64': base64
              };
              $_onImageUploadPostMessage
            };
            reader.onerror = function (_) {
              const newObject = {
                 'lastModified': files[0].lastModified,
                 'lastModifiedDate': files[0].lastModifiedDate,
                 'name': files[0].name,
                 'size': files[0].size,
                 'type': files[0].type,
                 'base64': base64
              };
              $_onImageUploadPostMessage
            };
            reader.readAsDataURL(files[0]);
''';

  String get _onImageUploadPostMessage => _callHandler(
        functionName: "onImageUpload",
        extra: 'JSON.stringify(newObject)',
      );

  @override
  String get onImageUploadErrorCallback => onEventCallback(
        eventName: "onImageUploadError",
        callback: javaScriptFunction(
          args: const ["file", "error"],
          body: _onImageUploadErrorCallbackBody,
        ),
      );

  String get _onImageUploadErrorCallbackBody => '''
                if (typeof file === 'string') {
                  ${_callHandler(functionName: "onImageUploadError", extra: "file, error")}
                } else {
                  const newObject = {
                    'lastModified': file.lastModified,
                    'lastModifiedDate': file.lastModifiedDate,
                    'name': file.name,
                    'size': file.size,
                    'type': file.type,
                  };
                  ${_callHandler(functionName: "onImageUploadError", extra: "JSON.stringify(newObject), error")}
                }
''';

  @override
  String get onKeyDownCallback => onEventHandler(
        eventName: "summernote.keydown",
        handler: javaScriptFunction(
          args: const ["_", "e"],
          body: _callHandler(functionName: "onKeyDown", extra: "e.keyCode"),
        ),
      );

  @override
  String get onKeyUpCallback => onEventHandler(
        eventName: "summernote.keyup",
        handler: javaScriptFunction(
          args: const ["_", "e"],
          body: _callHandler(functionName: "onKeyUp", extra: "e.keyCode"),
        ),
      );

  @override
  String get onMouseDownCallback => onEventHandler(
        eventName: "summernote.mousedown",
        handler: javaScriptFunction(
          args: const ["_"],
          body: _callHandler(functionName: "onMouseDown", extra: "'fired'"),
        ),
      );

  @override
  String get onMouseUpCallback => onEventHandler(
        eventName: "summernote.mouseup",
        handler: javaScriptFunction(
          args: const ["_"],
          body: _callHandler(functionName: "onMouseUp", extra: "'fired'"),
        ),
      );

  @override
  String get onPasteCallback => onEventHandler(
        eventName: "summernote.paste",
        handler: javaScriptFunction(
          args: const ["_"],
          body: _callHandler(functionName: "onPaste", extra: "'fired'"),
        ),
      );

  @override
  String get onScrollCallback => onEventHandler(
        eventName: "summernote.scroll",
        handler: javaScriptFunction(
          args: const ["_"],
          body: _callHandler(functionName: "onScroll", extra: "'fired'"),
        ),
      );

  SummernoteAdapterInappWebView({
    required super.key,
    super.divSelector = "\$('#summernote-2')",
    super.callbacks,
    super.height = 30,
  });

  /// Builds a JavaScript code which will be used to send a message to the parent window.
  ///
  /// The message will using the `window.flutter_inappwebview.callHandler` method.
  ///
  /// [extra] is an optional parameter which will be added to the message.
  String _callHandler({
    required String functionName,
    String? extra,
  }) {
    var effectiveExtra = "";
    if (extra != null) effectiveExtra = ", $extra";
    return 'window.flutter_inappwebview.callHandler("$functionName"$effectiveExtra);';
  }
}

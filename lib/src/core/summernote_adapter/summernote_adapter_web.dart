import 'summernote_adapter.dart';

class SummernoteAdapterWeb extends SummernoteAdapter {
  @override
  String get onBeforeCommandCallback => onEventHandler(
        eventName: "summernote.before.command",
        handler: javaScriptFunction(
          args: ["_", "contents", "\$editable"],
          body: _postMessage(functionName: "onBeforeCommand", extra: '"contents": contents'),
        ),
      );

  @override
  String get onBlurCallback => onEventHandler(
        eventName: "summernote.blur",
        handler: javaScriptFunction(
          args: const [],
          body: _postMessage(functionName: "onBlur"),
        ),
      );

  @override
  String get onBlurCodeviewCallback => onEventHandler(
        eventName: "summernote.blur.codeview",
        handler: javaScriptFunction(
          args: const [],
          body: _postMessage(functionName: "onBlurCodeview"),
        ),
      );

  @override
  String get onChangeCodeviewCallback => onEventHandler(
        eventName: "summernote.change.codeview",
        handler: javaScriptFunction(
          args: const ["_", "contents", "\$editable"],
          body: _postMessage(functionName: "onChangeCodeview", extra: '"contents": contents'),
        ),
      );

  @override
  String get onDialogShownCallback => onEventHandler(
        eventName: "summernote.dialog.shown",
        handler: javaScriptFunction(
          args: const [],
          body: _postMessage(functionName: "onDialogShown"),
        ),
      );

  @override
  String get onEnterCallback => onEventHandler(
        eventName: "summernote.enter",
        handler: javaScriptFunction(
          args: const [],
          body: _postMessage(functionName: "onEnter"),
        ),
      );

  @override
  String get onFocusCallback => onEventHandler(
        eventName: "summernote.focus",
        handler: javaScriptFunction(
          args: const [],
          body: _postMessage(functionName: "onFocus"),
        ),
      );

  @override
  String get onImageLinkInsertCallback => onEventCallback(
        eventName: "onImageLinkInsert",
        callback: javaScriptFunction(
          args: const ["url"],
          body: _postMessage(functionName: "onImageLinkInsert", extra: '"url": url'),
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

  String get _onImageUploadPostMessage => _postMessage(
        functionName: "onImageUpload",
        extra:
            '"lastModified": files[0].lastModified, "lastModifiedDate": files[0].lastModifiedDate, "name": files[0].name, "size": files[0].size, "mimeType": files[0].type, "base64": base64',
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
                  ${_postMessage(functionName: "onImageUploadError", extra: '"base64": file, "error": error')}
                } else {
                  ${_postMessage(functionName: "onImageUploadError", extra: '"lastModified": file.lastModified, "lastModifiedDate": file.lastModifiedDate, "name": file.name, "size": file.size, "mimeType": file.type, "error": error')}
                }
''';

  @override
  String get onKeyDownCallback => onEventHandler(
        eventName: "summernote.keydown",
        handler: javaScriptFunction(
          args: const ["_", "e"],
          body: _postMessage(functionName: "onKeyDown", extra: '"keyCode": e.keyCode'),
        ),
      );

  @override
  String get onKeyUpCallback => onEventHandler(
        eventName: "summernote.keyup",
        handler: javaScriptFunction(
          args: const ["_", "e"],
          body: _postMessage(functionName: "onKeyUp", extra: '"keyCode": e.keyCode'),
        ),
      );

  @override
  String get onMouseDownCallback => onEventHandler(
        eventName: "summernote.mousedown",
        handler: javaScriptFunction(
          args: const ["_"],
          body: _postMessage(functionName: "onMouseDown"),
        ),
      );

  @override
  String get onMouseUpCallback => onEventHandler(
        eventName: "summernote.mouseup",
        handler: javaScriptFunction(
          args: const ["_"],
          body: _postMessage(functionName: "onMouseUp"),
        ),
      );

  @override
  String get onPasteCallback => onEventHandler(
        eventName: "summernote.paste",
        handler: javaScriptFunction(
          args: const ["_"],
          body: _postMessage(functionName: "onPaste"),
        ),
      );

  @override
  String get onScrollCallback => onEventHandler(
        eventName: "summernote.scroll",
        handler: javaScriptFunction(
          args: const ["_"],
          body: _postMessage(functionName: "onScroll"),
        ),
      );

  SummernoteAdapterWeb({
    required super.key,
    super.divSelector = "\$('#summernote-2')",
    super.callbacks,
    super.height = 30,
  });

  /// Builds a JavaScript code which will be used to send a message to the parent window.
  ///
  /// Used when the app is compiled for web.
  /// [functionName] is the name of the javascript function to be called.
  /// [extra] is extra parameters to be passed to the function. This needs to be a string due to
  /// limitation of converting JSON to string.
  String _postMessage({
    required String functionName,
    String? extra,
  }) {
    var effectiveExtra = "";
    if (extra?.trim().isNotEmpty ?? false) {
      effectiveExtra = ", $extra";
    }
    return 'window.parent.postMessage(JSON.stringify({"view": "$key", "type": "toDart: $functionName" $effectiveExtra}), "*");';
  }
}

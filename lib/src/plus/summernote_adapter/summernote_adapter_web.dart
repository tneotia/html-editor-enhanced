import 'package:html_editor_enhanced/src/plus/core/editor_callbacks.dart';
import 'package:html_editor_enhanced/src/plus/core/editor_event.dart';
import 'package:html_editor_enhanced/src/plus/core/enums.dart';

import 'summernote_adapter.dart';

class SummernoteAdapterWeb extends SummernoteAdapter {
  @override
  String get platformSpecificJavascript => '''
function handleMessage(e) {
  if (e && e.data && e.data.includes("toIframe")) {
  logDebug("Received toIframe message from parent: " + e.data);
    const data = JSON.parse(e.data);
    if (data["key"] != $key) {
      logDebug("Ignoring message for view: " + data["view"])
      return;
    }
    if (data["method"] == "setHeight") {
      logDebug("Setting height: " + data["payload"]);
      ${editorHeight(height: 'data["payload"]')}
    }
    else if (data["method"] == "setWidth") {
      logDebug("Setting width: " + data["payload"]);
      ${editorWidth(width: 'data["payload"]')}
    } 
  }
  else if (e && e.data && e.data.includes("toSummernote")) {
    logDebug("Received toSummernote message from parent: " + e.data);
    const data = JSON.parse(e.data);
    const method = data["method"];
    const payload = data["payload"];
    if (payload) {
      if (method == "setHtml") {
        const currentValue = ${callSummernoteMethod(method: 'code')}
        logDebug("Current value: " + currentValue);
        if (currentValue == payload) {
          return;
        }
      }
      logDebug("Setting value: " + payload);
      ${callSummernoteMethod(method: 'code', payload: 'payload')}
    } 
    else {
      logDebug("Calling method: " + method);
      if (method == "${const EditorToggleView().method}" && ${resizeMode == ResizeMode.resizeToParent}) {
        resizeToParent();
      }
      ${callSummernoteMethod(method: 'method', wrapMethod: false)}
    }
  }
}

window.parent.addEventListener('message', handleMessage, false);
''';

  SummernoteAdapterWeb({
    required super.key,
    super.summernoteSelector = "\$('#summernote-2')",
    super.resizeMode = ResizeMode.resizeToParent,
  });

  @override
  String summernoteInit({
    String initialText = "",
    String hintText = "",
    String summernoteToolbar = "[]",
    bool spellCheck = false,
    int maximumFileSize = 10485760,
    String customOptions = "",
    List<String> summernoteCallbacks = const [],
  }) {
    return '''
<script type="text/javascript">
\$(document).ready(function () {
  ${super.summernoteInit(
      hintText: hintText,
      summernoteToolbar: summernoteToolbar,
      spellCheck: spellCheck,
      maximumFileSize: maximumFileSize,
      customOptions: customOptions,
      summernoteCallbacks: summernoteCallbacks,
    )}
});
</script> 
''';
  }

  @override
  String messageHandler({
    required EditorCallbacks event,
    String? payload,
  }) {
    final effectivePayload = payload ?? "null";
    return 'window.parent.postMessage(JSON.stringify({"key": "$key", "type": "toDart", "method": "$event", "payload": $effectivePayload}), "*");';
  }
}

import 'package:html_editor_enhanced/src/plus/core/editor_callbacks.dart';

import '../core/enums.dart';
import 'summernote_adapter.dart';

class SummernoteAdapterInappWebView extends SummernoteAdapter {
  @override
  String get platformSpecificJavascript => """
""";

  SummernoteAdapterInappWebView({
    required super.key,
    super.summernoteSelector = "\$('#summernote-2')",
    super.resizeMode = ResizeMode.resizeToParent,
    super.enableOnBlur = false,
    super.enableOnFocus = false,
    super.enableOnImageLinkInsert = false,
  });

  @override
  String messageHandler({
    required EditorCallbacks event,
    String? payload,
  }) {
    final effectivePayload = (payload != null) ? ", 'payload': $payload" : "";
    return 'window.flutter_inappwebview.callHandler("onSummernoteEvent", JSON.stringify({"key": "$key", "type": "toDart", "method": "$event" $effectivePayload}));';
  }
}

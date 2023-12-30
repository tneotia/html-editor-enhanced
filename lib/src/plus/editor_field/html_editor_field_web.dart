import 'dart:async';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html_editor_enhanced/src/plus/core/editor_callbacks.dart';
import 'package:html_editor_enhanced/src/plus/core/editor_event.dart';
import 'package:html_editor_enhanced/src/plus/core/editor_message.dart';
import 'package:html_editor_enhanced/src/plus/core/editor_value.dart';

import '../core/enums.dart';
import '../editor_controller.dart';
import '../summernote_adapter/summernote_adapter.dart';

/// {@macro HtmlEditorField}
///
/// This is used for web.
class HtmlEditorField extends StatefulWidget {
  /// {@macro ResizeMode}
  final ResizeMode resizeMode;

  /// {@macro HtmlEditorField.controller}
  final HtmlEditorController controller;

  /// {@macro HtmlEditorField.themeData}
  final ThemeData? themeData;

  const HtmlEditorField({
    super.key,
    required this.controller,
    this.resizeMode = ResizeMode.resizeToParent,
    this.themeData,
  });

  @override
  State<HtmlEditorField> createState() => _HtmlEditorFieldState();
}

class _HtmlEditorFieldState extends State<HtmlEditorField> {
  late final String _viewId;
  late final SummernoteAdapter _adapter;
  late final HtmlEditorController _controller;
  late final ValueNotifier<HtmlEditorValue> _currentValueNotifier;
  late final StreamSubscription<EditorEvent> _eventsSubscription;

  late final StreamSubscription<EditorMessage> _messagesSubscription;
  late final Future<void> _initFuture;
  late final html.IFrameElement _iframe;

  ThemeData? _themeData;

  HtmlEditorValue get _currentValue => _currentValueNotifier.value;
  String get _assetsPath => "packages/html_editor_enhanced/assets";
  String get _filePath => "$_assetsPath/summernote-no-plugins.html";
  String get _jqueryPath => "assets/$_assetsPath/jquery.min.js";
  String get _cssPath => "assets/$_assetsPath/summernote-lite.min.css";
  String get _summernotePath => "assets/$_assetsPath/summernote-lite.min.js";

  Stream<EditorMessage> get _iframeMessagesStream =>
      html.window.onMessage.map((event) => EditorMessage.fromJson(jsonDecode(event.data)));

  @override
  void initState() {
    super.initState();
    _themeData = widget.themeData;
    _viewId = DateTime.now().millisecondsSinceEpoch.toString();
    _adapter = SummernoteAdapter.web(
      key: _viewId,
      resizeMode: widget.resizeMode,
    );
    _controller = widget.controller;
    _controller.addListener(_controllerListener);
    _currentValueNotifier = ValueNotifier(_controller.clonedValue);
    _eventsSubscription = _controller.events.listen(_parseEvents);
    _messagesSubscription = _iframeMessagesStream.listen(_parseHandlerMessages);
    _iframe = _initIframe();
    _initFuture = _loadSummernote();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _eventsSubscription.cancel();
    _controller.removeListener(_controllerListener);
    _currentValueNotifier.dispose();
    _messagesSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<void>(
        key: ValueKey("webview_key_$_viewId"),
        future: _initFuture,
        builder: (context, snapshot) => switch (snapshot.connectionState) {
          ConnectionState.done => Directionality(
              textDirection: TextDirection.ltr,
              child: HtmlElementView(viewType: _viewId),
            ),
          _ => const SizedBox.shrink(),
        },
      );

  Future<void> _loadSummernote() async {
    final summernoteInit = '''
${_adapter.summernoteInit(
      summernoteCallbacks: _adapter.summernoteCallbacks(),
    )}
<style>
${_adapter.css(colorScheme: _themeData?.colorScheme)}
</style>
''';
    final defaultHtml = await rootBundle.loadString(_filePath);
    _iframe.srcdoc = defaultHtml
        .replaceFirst('"jquery.min.js"', '"$_jqueryPath"')
        .replaceFirst('"summernote-lite.min.css"', '"$_cssPath"')
        .replaceFirst('"summernote-lite.min.js"', '"$_summernotePath"')
        .replaceFirst('<!--summernoteScripts-->', summernoteInit);
  }

  void _parseHandlerMessages(EditorMessage message) {
    if (message.type != "toDart") return;
    debugPrint("Received message from iframe: $message");
    return switch (EditorCallbacks.fromMessage(message)) {
      EditorCallbacks.onInit => _onInit(),
      EditorCallbacks.onChange => _onChange(message),
      EditorCallbacks.onChangeCodeview => _onChange(message),
      _ => debugPrint("Uknown message received from iframe: $message"),
    };
  }

  void _onInit() {
    if (_currentValue.hasValue) _parseEvents(EditorSetHtml(payload: _currentValue.html));
  }

  void _onChange(EditorMessage message) {
    if (message.payload != _currentValue.html) {
      _currentValueNotifier.value = _currentValue.copyWith(html: message.payload);
      _controller.html = message.payload!;
    }
  }

  void _controllerListener() {
    debugPrint("Controller listener called");
    if (_controller.html != _currentValue.html) {
      _parseEvents(EditorSetHtml(payload: _controller.html));
    }
  }

  void _parseEvents(EditorEvent event) async {
    const jsonEncoder = JsonEncoder();
    final message = EditorMessage.fromEvent(
      key: _viewId,
      event: event,
    );
    html.window.postMessage(jsonEncoder.convert(message.toJson()), '*');
  }

  html.IFrameElement _initIframe() {
    final iframe = html.IFrameElement();
    iframe.style.height = "100%";
    iframe.style.width = "100%";
    iframe.style.border = "none";
    iframe.style.overflow = "hidden";
    iframe.style.padding = "0";
    iframe.style.margin = "0";
    ui.platformViewRegistry.registerViewFactory(_viewId, (int viewId) => iframe);
    return iframe;
  }
}

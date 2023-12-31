import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:html_editor_enhanced/src/plus/core/editor_callbacks.dart';
import 'package:html_editor_enhanced/src/plus/summernote_adapter/summernote_adapter_inappwebview.dart';

import '../editor_controller.dart';
import '../core/editor_event.dart';
import '../core/editor_value.dart';
import '../core/enums.dart';
import '../summernote_adapter/summernote_adapter.dart';
import '../core/editor_message.dart';

/// {@macro HtmlEditorField}
///
/// This is used for mobile platforms.
class HtmlEditorField extends StatefulWidget {
  /// {@macro ResizeMode}
  final ResizeMode resizeMode;

  /// {@macro HtmlEditorField.intialMobileOptions}
  final InAppWebViewGroupOptions? intialMobileOptions;

  /// {@macro HtmlEditorField.controller}
  final HtmlEditorController controller;

  /// {@macro HtmlEditorField.themeData}
  final ThemeData? themeData;

  const HtmlEditorField({
    super.key,
    required this.controller,
    this.resizeMode = ResizeMode.resizeToParent,
    this.intialMobileOptions,
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

  late final StreamSubscription<bool> _keyboardVisibilitySubscription;
  late final InAppWebViewGroupOptions _initialOptions;

  ThemeData? _themeData;

  InAppWebViewController? _webviewController;

  HtmlEditorValue get _currentValue => _currentValueNotifier.value;
  String get _assetsPath => "packages/html_editor_enhanced/assets";
  String get _filePath => "$_assetsPath/summernote-no-plugins.html";
  String get _cssPath => "$_assetsPath/summernote-lite.min.css";
  String get _jqueryPath => "$_assetsPath/jquery.min.js";
  String get _summernotePath => "$_assetsPath/summernote-lite.min.js";

  @override
  void initState() {
    super.initState();
    _themeData = widget.themeData;
    _viewId = DateTime.now().millisecondsSinceEpoch.toString();
    _adapter = SummernoteAdapterInappWebView(
      key: _viewId,
      resizeMode: widget.resizeMode,
    );
    _controller = widget.controller;
    _controller.addListener(_controllerListener);
    _currentValueNotifier = ValueNotifier(_controller.clonedValue);
    _eventsSubscription = _controller.events.listen(_parseEvents);
    _initialOptions = widget.intialMobileOptions ??
        InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            javaScriptEnabled: true,
            transparentBackground: true,
            useShouldOverrideUrlLoading: true,
          ),
          android: AndroidInAppWebViewOptions(
            useHybridComposition: true,
            loadWithOverviewMode: true,
          ),
        );
    _keyboardVisibilitySubscription = KeyboardVisibilityController().onChange.listen(
          _onKeyboardVisibilityChanged,
        );
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
    _keyboardVisibilitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => InAppWebView(
        key: ValueKey("webview_key_$_viewId"),
        initialFile: _filePath,
        onWebViewCreated: (controller) => _webviewController ??= controller,
        onLoadStop: (controller, url) {
          debugPrint("onLoadStop url: $url");
          _loadSummernote();
        },
        onWindowFocus: (controller) => debugPrint("onWindowFocus"),
        onWindowBlur: (controller) => debugPrint("onWindowBlur"),
        onLoadError: (controller, url, code, message) => debugPrint("message: $message"),
        initialOptions: _initialOptions,
        shouldOverrideUrlLoading: (controller, action) async {
          /// TODO; implement
          /// if (!action.request.url.toString().contains(_filePath)) {
          ///   return (await widget.callbacks?.onNavigationRequestMobile
          ///           ?.call(action.request.url.toString())) as NavigationActionPolicy? ??
          ///       NavigationActionPolicy.ALLOW;
          /// }
          return NavigationActionPolicy.ALLOW;
        },
        gestureRecognizers: {
          Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer()),
          Factory<LongPressGestureRecognizer>(() => LongPressGestureRecognizer()),
        },
        onConsoleMessage: (controller, message) => debugPrint(message.message),
      );

  Future<void> _loadSummernote() async {
    _webviewController!.addJavaScriptHandler(
      handlerName: "onSummernoteEvent",
      callback: (arguments) => _parseHandlerMessages(
        EditorMessage.fromJson(jsonDecode(arguments.first.toString())),
      ),
    );
    await _webviewController!.injectCSSFileFromAsset(assetFilePath: _cssPath);
    await _webviewController!.injectCSSCode(
      source: _adapter.css(colorScheme: _themeData?.colorScheme),
    );
    await _webviewController!.injectJavascriptFileFromAsset(assetFilePath: _jqueryPath);
    await _webviewController!.injectJavascriptFileFromAsset(assetFilePath: _summernotePath);
    await _webviewController!.evaluateJavascript(
      source: _adapter.summernoteInit(
        summernoteCallbacks: _adapter.summernoteCallbacks(),
      ),
    );
  }

  void _parseHandlerMessages(EditorMessage message) {
    debugPrint("Received message from editor: $message");
    return switch (EditorCallbacks.fromMessage(message)) {
      EditorCallbacks.onInit => _onInit(),
      EditorCallbacks.onChange => _onChange(message),
      EditorCallbacks.onChangeCodeview => _onChange(message),
      _ => debugPrint("Uknown message received from editor: $message"),
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

  Future<void> _controllerListener() async {
    debugPrint("Controller listener called");
    if (_controller.html != _currentValue.html) {
      _parseEvents(EditorSetHtml(payload: _controller.html));
    }
  }

  void _parseEvents(EditorEvent event) {
    debugPrint("Sending message to editor: $event");
    (switch (event) {
      EditorReload() => _webviewController!.reload(),
      _ => _webviewController!.evaluateJavascript(
          source: switch (event) {
            EditorSetHtml(:final method, :final payload) => "$method(${jsonEncode(payload)})",
            EditorResizeToParent(:final method) => "$method()",
            _ => _adapter.callSummernoteMethod(
                method: event.method,
                payload: (event.payload != null) ? jsonEncode(event.payload) : null,
              ),
          },
        ),
    });

    if (event == const EditorToggleView()) {
      _parseEvents(const EditorResizeToParent());
    }
  }

  /// Function which clears the focus from the editor once the keyboard is hidden.
  ///
  /// There are some issues with the keyboard on mobile platforms, so this is a workaround.
  /// Usually MediaQuery.of(context).viewInsets gets updated if the keyboard is opened/closed,
  /// but this doesn't seem to be the case with the editor. Don't know if is from InAppWebView or
  /// the platform view itself.
  /// More so, if the keyboard is closed by tapping on the back button, the focus is not cleared.
  /// So we need to manually clear the focus.
  void _onKeyboardVisibilityChanged(bool visible) {
    if (!visible) _webviewController?.clearFocus();
  }
}

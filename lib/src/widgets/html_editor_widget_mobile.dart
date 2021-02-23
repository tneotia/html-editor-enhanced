import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:html_editor_enhanced/utils/toolbar_icon.dart';

bool callbacksInitialized = false;

class HtmlEditorWidget extends StatelessWidget {
  HtmlEditorWidget({
    Key key,
    this.value,
    this.height,
    this.showBottomToolbar,
    this.hint,
    this.callbacks,
    this.toolbar,
    this.darkMode
  }) : super(key: key);

  final String value;
  final double height;
  final bool showBottomToolbar;
  final String hint;
  final UniqueKey webViewKey = UniqueKey();
  final Callbacks callbacks;
  final List<Toolbar> toolbar;
  final bool darkMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: InAppWebView(
            initialFile: 'packages/html_editor_enhanced/assets/summernote.html',
            onWebViewCreated: (webViewController) {
              controller = webViewController;
            },
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                javaScriptEnabled: true,
                debuggingEnabled: true,
                transparentBackground: true
              ),
              //todo flutter_inappwebview 5.0.0
              /*android: AndroidInAppWebViewOptions(
                    useHybridComposition: true,
                  )*/
            ),
            gestureRecognizers: {
              Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer())
            },
            onConsoleMessage: (controller, consoleMessage) {
              String message = consoleMessage.message;
              //todo determine whether this processing is necessary
              if (message.isEmpty ||
                  message == "<p></p>" ||
                  message == "<p><br></p>" ||
                  message == "<p><br/></p>") {
                message = "";
              }
              text = message;
            },
            onLoadStop: (InAppWebViewController controller, String url) async {
              if (url.contains("summernote.html")) {
                String summernoteToolbar = "[\n";
                for (Toolbar t in toolbar) {
                  summernoteToolbar = summernoteToolbar +
                      "['${t.getGroupName()}', ${t.getButtons()}],\n";
                }
                summernoteToolbar = summernoteToolbar + "],";
                controller.evaluateJavascript(source: """
                   \$('#summernote-2').summernote({
                      placeholder: "$hint",
                      tabsize: 2,
                      height: ${height - 125},
                      maxHeight: ${height - 125},
                      toolbar: $summernoteToolbar
                      disableGrammar: false,
                      spellCheck: false
                    });
                """);
                if ((Theme.of(context).brightness == Brightness.dark || darkMode == true) && darkMode != false) {
                  String darkCSS = await rootBundle.loadString('packages/html_editor_enhanced/assets/summernote-lite-dark.css');
                  var bytes = utf8.encode(darkCSS);
                  var base64Str = base64.encode(bytes);
                  controller.evaluateJavascript(
                      source: "javascript:(function() {" +
                          "var parent = document.getElementsByTagName('head').item(0);" +
                          "var style = document.createElement('style');" +
                          "style.type = 'text/css';" +
                          "style.innerHTML = window.atob('" +
                          base64Str + "');" +
                          "parent.appendChild(style)" +
                          "})()");
                }
                //set the text once the editor is loaded
                if (value != null) {
                  HtmlEditor.setText(value);
                }
                //initialize callbacks
                if (callbacks != null && !callbacksInitialized) {
                  addJSCallbacks();
                  addJSHandlers();
                  callbacksInitialized = true;
                }
              }
            },
          ),
        ),
        showBottomToolbar ? Divider(height: 0) : Container(height: 0, width: 0),
        showBottomToolbar ? Padding(
          padding: const EdgeInsets.only(
              left: 4, right: 4, bottom: 8, top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              toolbarIcon(
                  context,
                  Icons.content_copy,
                  "Copy",
                  onTap: () async {
                    String data = await HtmlEditor.getText();
                    Clipboard.setData(new ClipboardData(text: data));
                  }
              ),
              toolbarIcon(
                  context,
                  Icons.content_paste,
                  "Paste",
                  onTap: () async {
                    ClipboardData data =
                    await Clipboard.getData(Clipboard.kTextPlain);
                    String txtIsi = data.text
                        .replaceAll("'", '\\"')
                        .replaceAll('"', '\\"')
                        .replaceAll("[", "\\[")
                        .replaceAll("]", "\\]")
                        .replaceAll("\n", "<br/>")
                        .replaceAll("\n\n", "<br/>")
                        .replaceAll("\r", " ")
                        .replaceAll('\r\n', " ");
                    HtmlEditor.insertHtml(txtIsi);
                  }
              ),
            ],
          ),
        ) : Container(height: 0, width: 0),
      ],
    );
  }

  void addJSCallbacks() {
    if (callbacks.onChange != null) {
      controller.evaluateJavascript(
        source: """
          \$('#summernote-2').on('summernote.change', function(_, contents, \$editable) {
            window.flutter_inappwebview.callHandler('onChange', contents);
          });
        """
      );
    }
    if (callbacks.onEnter != null) {
      controller.evaluateJavascript(
          source: """
          \$('#summernote-2').on('summernote.enter', function() {
            window.flutter_inappwebview.callHandler('onEnter', 'fired');
          });
        """
      );
    }
    if (callbacks.onFocus != null) {
      controller.evaluateJavascript(
          source: """
          \$('#summernote-2').on('summernote.focus', function() {
            window.flutter_inappwebview.callHandler('onFocus', 'fired');
          });
        """
      );
    }
    if (callbacks.onBlur != null) {
      controller.evaluateJavascript(
          source: """
          \$('#summernote-2').on('summernote.blur', function() {
            window.flutter_inappwebview.callHandler('onBlur', 'fired');
          });
        """
      );
    }
    if (callbacks.onBlurCodeview != null) {
      controller.evaluateJavascript(
          source: """
          \$('#summernote-2').on('summernote.blur.codeview', function() {
            window.flutter_inappwebview.callHandler('onBlurCodeview', 'fired');
          });
        """
      );
    }
    if (callbacks.onKeyDown != null) {
      controller.evaluateJavascript(
          source: """
          \$('#summernote-2').on('summernote.keydown', function(_, e) {
            window.flutter_inappwebview.callHandler('onKeyDown', e.keyCode);
          });
        """
      );
    }
    if (callbacks.onKeyUp != null) {
      controller.evaluateJavascript(
          source: """
          \$('#summernote-2').on('summernote.keyup', function(_, e) {
            window.flutter_inappwebview.callHandler('onKeyUp', e.keyCode);
          });
        """
      );
    }
    if (callbacks.onPaste != null) {
      controller.evaluateJavascript(
          source: """
          \$('#summernote-2').on('summernote.paste', function(_) {
            window.flutter_inappwebview.callHandler('onPaste', 'fired');
          });
        """
      );
    }
  }

  void addJSHandlers() {
    if (callbacks.onChange != null) {
      controller.addJavaScriptHandler(handlerName: 'onChange', callback: (contents) {
        callbacks.onChange.call(contents.first.toString());
      });
    }
    if (callbacks.onEnter != null) {
      controller.addJavaScriptHandler(handlerName: 'onEnter', callback: (_) {
        callbacks.onEnter.call();
      });
    }
    if (callbacks.onFocus != null) {
      controller.addJavaScriptHandler(handlerName: 'onFocus', callback: (_) {
        callbacks.onFocus.call();
      });
    }
    if (callbacks.onBlur != null) {
      controller.addJavaScriptHandler(handlerName: 'onBlur', callback: (_) {
        callbacks.onBlur.call();
      });
    }
    if (callbacks.onBlurCodeview != null) {
      controller.addJavaScriptHandler(handlerName: 'onBlurCodeview', callback: (_) {
        callbacks.onBlurCodeview.call();
      });
    }
    if (callbacks.onKeyDown != null) {
      controller.addJavaScriptHandler(handlerName: 'onKeyDown', callback: (keyCode) {
        callbacks.onKeyDown.call(keyCode.first);
      });
    }
    if (callbacks.onKeyUp != null) {
      controller.addJavaScriptHandler(handlerName: 'onKeyUp', callback: (keyCode) {
        callbacks.onKeyUp.call(keyCode.first);
      });
    }
    if (callbacks.onPaste != null) {
      controller.addJavaScriptHandler(handlerName: 'onPaste', callback: (_) {
        callbacks.onPaste.call();
      });
    }
  }
}
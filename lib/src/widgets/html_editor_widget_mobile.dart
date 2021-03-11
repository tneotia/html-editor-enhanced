import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:html_editor_enhanced/utils/plugins.dart';
import 'package:html_editor_enhanced/utils/toolbar_icon.dart';

bool callbacksInitialized = false;

/// The HTML Editor widget itself, for mobile (uses flutter_inappwebview)
class HtmlEditorWidget extends StatelessWidget {
  HtmlEditorWidget(
      {Key? key,
      required this.widgetController,
      this.value,
      required this.height,
      required this.showBottomToolbar,
      this.hint,
      this.callbacks,
      required this.toolbar,
      required this.plugins,
      this.darkMode})
      : super(key: key);

  final HtmlEditorController widgetController;
  final String? value;
  final double height;
  final bool showBottomToolbar;
  final String? hint;
  final UniqueKey webViewKey = UniqueKey();
  final Callbacks? callbacks;
  final List<Toolbar> toolbar;
  final List<Plugins> plugins;
  final bool? darkMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: InAppWebView(
            initialFile: 'packages/html_editor_enhanced/assets/summernote.html',
            onWebViewCreated: (webViewController) {
              controllerMap[widgetController] = webViewController;
            },
            initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                    javaScriptEnabled: true, transparentBackground: true),
                android: AndroidInAppWebViewOptions(
                  useHybridComposition: true,
                )),
            gestureRecognizers: {
              Factory<VerticalDragGestureRecognizer>(
                  () => VerticalDragGestureRecognizer())
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
              widgetController.getTextStream!.add(message);
            },
            onLoadStop: (InAppWebViewController controller, Uri? uri) async {
              String url = uri.toString();
              if (url.contains("summernote.html")) {
                String summernoteToolbar = "[\n";
                for (Toolbar t in toolbar) {
                  summernoteToolbar = summernoteToolbar +
                      "['${t.getGroupName()}', ${t.getButtons()}],\n";
                }
                if (plugins.isNotEmpty) {
                  summernoteToolbar = summernoteToolbar + "['plugins', [";
                  for (Plugins p in plugins) {
                    summernoteToolbar = summernoteToolbar +
                        "'${p.getToolbarString()}'" +
                        (p == plugins.last ? "]]\n" : ", ");
                  }
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
                if ((Theme.of(context).brightness == Brightness.dark ||
                        darkMode == true) &&
                    darkMode != false) {
                  String darkCSS =
                      "<link href=\"summernote-lite-dark.css\" rel=\"stylesheet\">";
                  await controller.evaluateJavascript(
                      source: "\$('head').append('$darkCSS');");
                }
                //set the text once the editor is loaded
                if (value != null) {
                  widgetController.setText(value!);
                }
                //initialize callbacks
                if (callbacks != null && !callbacksInitialized) {
                  addJSCallbacks(callbacks!);
                  addJSHandlers(callbacks!);
                  callbacksInitialized = true;
                }
                //call onInit callback
                if (callbacks != null && callbacks!.onInit != null)
                  callbacks!.onInit!.call();
              }
            },
          ),
        ),
        showBottomToolbar ? Divider(height: 0) : Container(height: 0, width: 0),
        showBottomToolbar
            ? Padding(
                padding:
                    const EdgeInsets.only(left: 4, right: 4, bottom: 8, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    toolbarIcon(context, Icons.content_copy, "Copy",
                        onTap: () async {
                      String? data = await widgetController.getText();
                      Clipboard.setData(new ClipboardData(text: data));
                    }),
                    toolbarIcon(context, Icons.content_paste, "Paste",
                        onTap: () async {
                      ClipboardData? data =
                          await Clipboard.getData(Clipboard.kTextPlain);
                      if (data != null) {
                        String txtIsi = data.text!
                            .replaceAll("'", '\\"')
                            .replaceAll('"', '\\"')
                            .replaceAll("[", "\\[")
                            .replaceAll("]", "\\]")
                            .replaceAll("\n", "<br/>")
                            .replaceAll("\n\n", "<br/>")
                            .replaceAll("\r", " ")
                            .replaceAll('\r\n', " ");
                        widgetController.insertHtml(txtIsi);
                      }
                    }),
                  ],
                ),
              )
            : Container(height: 0, width: 0),
      ],
    );
  }

  /// adds the callbacks set by the user into the scripts
  void addJSCallbacks(Callbacks c) {
    if (c.onChange != null) {
      controllerMap[widgetController].evaluateJavascript(source: """
          \$('#summernote-2').on('summernote.change', function(_, contents, \$editable) {
            window.flutter_inappwebview.callHandler('onChange', contents);
          });
        """);
    }
    if (c.onEnter != null) {
      controllerMap[widgetController].evaluateJavascript(source: """
          \$('#summernote-2').on('summernote.enter', function() {
            window.flutter_inappwebview.callHandler('onEnter', 'fired');
          });
        """);
    }
    if (c.onFocus != null) {
      controllerMap[widgetController].evaluateJavascript(source: """
          \$('#summernote-2').on('summernote.focus', function() {
            window.flutter_inappwebview.callHandler('onFocus', 'fired');
          });
        """);
    }
    if (c.onBlur != null) {
      controllerMap[widgetController].evaluateJavascript(source: """
          \$('#summernote-2').on('summernote.blur', function() {
            window.flutter_inappwebview.callHandler('onBlur', 'fired');
          });
        """);
    }
    if (c.onBlurCodeview != null) {
      controllerMap[widgetController].evaluateJavascript(source: """
          \$('#summernote-2').on('summernote.blur.codeview', function() {
            window.flutter_inappwebview.callHandler('onBlurCodeview', 'fired');
          });
        """);
    }
    if (c.onKeyDown != null) {
      controllerMap[widgetController].evaluateJavascript(source: """
          \$('#summernote-2').on('summernote.keydown', function(_, e) {
            window.flutter_inappwebview.callHandler('onKeyDown', e.keyCode);
          });
        """);
    }
    if (c.onKeyUp != null) {
      controllerMap[widgetController].evaluateJavascript(source: """
          \$('#summernote-2').on('summernote.keyup', function(_, e) {
            window.flutter_inappwebview.callHandler('onKeyUp', e.keyCode);
          });
        """);
    }
    if (c.onPaste != null) {
      controllerMap[widgetController].evaluateJavascript(source: """
          \$('#summernote-2').on('summernote.paste', function(_) {
            window.flutter_inappwebview.callHandler('onPaste', 'fired');
          });
        """);
    }
  }

  /// creates flutter_inappwebview JavaScript Handlers to handle any callbacks the
  /// user has defined
  void addJSHandlers(Callbacks c) {
    if (c.onChange != null) {
      controllerMap[widgetController].addJavaScriptHandler(
          handlerName: 'onChange',
          callback: (contents) {
            c.onChange!.call(contents.first.toString());
          });
    }
    if (c.onEnter != null) {
      controllerMap[widgetController].addJavaScriptHandler(
          handlerName: 'onEnter',
          callback: (_) {
            c.onEnter!.call();
          });
    }
    if (c.onFocus != null) {
      controllerMap[widgetController].addJavaScriptHandler(
          handlerName: 'onFocus',
          callback: (_) {
            c.onFocus!.call();
          });
    }
    if (c.onBlur != null) {
      controllerMap[widgetController].addJavaScriptHandler(
          handlerName: 'onBlur',
          callback: (_) {
            c.onBlur!.call();
          });
    }
    if (c.onBlurCodeview != null) {
      controllerMap[widgetController].addJavaScriptHandler(
          handlerName: 'onBlurCodeview',
          callback: (_) {
            c.onBlurCodeview!.call();
          });
    }
    if (c.onKeyDown != null) {
      controllerMap[widgetController].addJavaScriptHandler(
          handlerName: 'onKeyDown',
          callback: (keyCode) {
            c.onKeyDown!.call(keyCode.first);
          });
    }
    if (c.onKeyUp != null) {
      controllerMap[widgetController].addJavaScriptHandler(
          handlerName: 'onKeyUp',
          callback: (keyCode) {
            c.onKeyUp!.call(keyCode.first);
          });
    }
    if (c.onPaste != null) {
      controllerMap[widgetController].addJavaScriptHandler(
          handlerName: 'onPaste',
          callback: (_) {
            c.onPaste!.call();
          });
    }
  }
}

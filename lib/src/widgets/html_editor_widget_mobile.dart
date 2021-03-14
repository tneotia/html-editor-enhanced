import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:html_editor_enhanced/utils/plugins.dart';
import 'package:html_editor_enhanced/utils/toolbar_icon.dart';

/// The HTML Editor widget itself, for mobile (uses InAppWebView)
class HtmlEditorWidget extends StatefulWidget {
  HtmlEditorWidget({
    Key? key,
    required this.controller,
    this.value,
    this.hint,
    this.callbacks,
    required this.toolbar,
    required this.plugins,
    required this.options,
  }) : super(key: key);

  final HtmlEditorController controller;
  final String? value;
  final String? hint;
  final Callbacks? callbacks;
  final List<Toolbar> toolbar;
  final List<Plugins> plugins;
  final HtmlEditorOptions options;

  _HtmlEditorWidgetMobileState createState() => _HtmlEditorWidgetMobileState();
}

/// State for the mobile Html editor widget
///
/// A stateful widget is necessary here to allow the height to dynamically adjust.
class _HtmlEditorWidgetMobileState extends State<HtmlEditorWidget> {
  /// Tracks whether the callbacks were initialized or not to prevent re-initializing them
  bool callbacksInitialized = false;

  /// The actual height of the editor, used to automatically set the height
  late double actualHeight;

  /// The file path to the html code
  late String filePath;

  @override
  void initState() {
    actualHeight = widget.options.height + 125;
    if (widget.options.filePath != null) {
      filePath = widget.options.filePath!;
    } else if (widget.plugins.isEmpty) {
      filePath = 'packages/html_editor_enhanced/assets/summernote-no-plugins.html';
    } else {
      filePath = 'packages/html_editor_enhanced/assets/summernote.html';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.options.autoAdjustHeight ? actualHeight : widget.options.height,
      decoration: widget.options.decoration,
      child: Column(
        children: <Widget>[
          Expanded(
            child: InAppWebView(
              initialFile: filePath,
              onWebViewCreated: (webViewController) {
                controllerMap[widget.controller] = webViewController;
              },
              initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                      javaScriptEnabled: true, transparentBackground: true),
                  android: AndroidInAppWebViewOptions(
                    useHybridComposition: true,
                    loadWithOverviewMode: true,
                  )),
              gestureRecognizers: {
                Factory<VerticalDragGestureRecognizer>(
                    () => VerticalDragGestureRecognizer())
              },
              onLoadStop: (InAppWebViewController controller, Uri? uri) async {
                String url = uri.toString();
                if (url.contains(filePath)) {
                  String summernoteToolbar = "[\n";
                  String summernoteCallbacks = "callbacks: {";
                  for (Toolbar t in widget.toolbar) {
                    summernoteToolbar = summernoteToolbar +
                        "['${t.getGroupName()}', ${t.getButtons(listStyles: widget.plugins.whereType<SummernoteListStyles>().isNotEmpty)}],\n";
                  }
                  if (widget.plugins.isNotEmpty) {
                    summernoteToolbar = summernoteToolbar + "['plugins', [";
                    for (Plugins p in widget.plugins) {
                      summernoteToolbar = summernoteToolbar +
                          (p.getToolbarString().isNotEmpty
                              ? "'${p.getToolbarString()}'"
                              : "") +
                          (p == widget.plugins.last
                              ? "]]\n"
                              : p.getToolbarString().isNotEmpty
                                  ? ", "
                                  : "");
                      if (p is SummernoteAtMention) {
                        summernoteCallbacks = summernoteCallbacks +
                            """
                          \nsummernoteAtMention: {
                            getSuggestions: (value) => ${p.getMentions()},
                            onSelect: (value) => {
                              window.flutter_inappwebview.callHandler('onSelectMention', value);
                            },
                          },
                        """;
                        if (p.onSelect != null) {
                          controllerMap[widget.controller].addJavaScriptHandler(
                              handlerName: 'onSelectMention',
                              callback: (value) {
                                p.onSelect!.call(value.first.toString());
                              });
                        }
                      }
                      if (p is SummernoteFile) {
                        if (p.onFileUpload != null) {
                          summernoteCallbacks = summernoteCallbacks +
                              """
                            onFileUpload: function(files) {
                              var newObject  = {
                                 'lastModified': files[0].lastModified,
                                 'lastModifiedDate': files[0].lastModifiedDate,
                                 'name': files[0].name,
                                 'size': files[0].size,
                                 'type': files[0].type
                              };
                              window.flutter_inappwebview.callHandler('onFileUpload', JSON.stringify(newObject));
                            }
                        """;
                          controllerMap[widget.controller].addJavaScriptHandler(
                              handlerName: 'onFileUpload',
                              callback: (files) {
                                FileUpload file =
                                    fileUploadFromJson(files.first);
                                p.onFileUpload!.call(file);
                              });
                        }
                      }
                    }
                  }
                  summernoteToolbar = summernoteToolbar + "],";
                  summernoteCallbacks = summernoteCallbacks + "}";
                  controller.evaluateJavascript(source: """
                     \$(document).ready(function () {
                        \$('#summernote-2').summernote({
                          placeholder: "${widget.hint}",
                          tabsize: 2,
                          height: ${widget.options.height},
                          toolbar: $summernoteToolbar
                          disableGrammar: false,
                          spellCheck: false,
                          $summernoteCallbacks
                        });
                      });
                  """);
                  if ((Theme.of(context).brightness == Brightness.dark ||
                          widget.options.darkMode == true) &&
                      widget.options.darkMode != false) {
                    String darkCSS =
                        "<link href=\"summernote-lite-dark.css\" rel=\"stylesheet\">";
                    await controller.evaluateJavascript(
                        source: "\$('head').append('$darkCSS');");
                  }
                  //set the text once the editor is loaded
                  if (widget.value != null)
                    widget.controller.setText(widget.value!);
                  //adjusts the height of the editor when it is loaded
                  if (widget.options.autoAdjustHeight) {
                    final docHeight = await controller.evaluateJavascript(
                        source: 'document.body.scrollHeight') as int?;
                    if ((docHeight != null) && mounted) {
                      setState(() {
                        actualHeight = docHeight + 40.0;
                      });
                    }
                  }
                  //initialize callbacks
                  if (widget.callbacks != null && !callbacksInitialized) {
                    addJSCallbacks(widget.callbacks!);
                    addJSHandlers(widget.callbacks!);
                    callbacksInitialized = true;
                  }
                  //call onInit callback
                  if (widget.callbacks != null &&
                      widget.callbacks!.onInit != null)
                    widget.callbacks!.onInit!.call();
                }
              },
            ),
          ),
          widget.options.showBottomToolbar
              ? Divider(height: 0)
              : Container(height: 0, width: 0),
          widget.options.showBottomToolbar
              ? Padding(
                  padding: const EdgeInsets.only(
                      left: 4, right: 4, bottom: 8, top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      toolbarIcon(context, Icons.content_copy, "Copy",
                          onTap: () async {
                        String? data = await widget.controller.getText();
                        Clipboard.setData(new ClipboardData(text: data));
                      }),
                      toolbarIcon(context, Icons.content_paste, "Paste",
                          onTap: () async {
                        ClipboardData? data =
                            await Clipboard.getData(Clipboard.kTextPlain);
                        if (data != null) {
                          String text = data.text!;
                          if (widget.controller.processInputHtml) {
                            text = text
                                .replaceAll("'", '\\"')
                                .replaceAll('"', '\\"')
                                .replaceAll("[", "\\[")
                                .replaceAll("]", "\\]")
                                .replaceAll("\n", "<br/>")
                                .replaceAll("\n\n", "<br/>")
                                .replaceAll("\r", " ")
                                .replaceAll('\r\n', " ");
                          }
                          widget.controller.insertHtml(text);
                        }
                      }),
                    ],
                  ),
                )
              : Container(height: 0, width: 0),
        ],
      ),
    );
  }

  /// adds the callbacks set by the user into the scripts
  void addJSCallbacks(Callbacks c) {
    if (c.onChange != null) {
      controllerMap[widget.controller].evaluateJavascript(source: """
          \$('#summernote-2').on('summernote.change', function(_, contents, \$editable) {
            window.flutter_inappwebview.callHandler('onChange', contents);
          });
        """);
    }
    if (c.onEnter != null) {
      controllerMap[widget.controller].evaluateJavascript(source: """
          \$('#summernote-2').on('summernote.enter', function() {
            window.flutter_inappwebview.callHandler('onEnter', 'fired');
          });
        """);
    }
    if (c.onFocus != null) {
      controllerMap[widget.controller].evaluateJavascript(source: """
          \$('#summernote-2').on('summernote.focus', function() {
            window.flutter_inappwebview.callHandler('onFocus', 'fired');
          });
        """);
    }
    if (c.onBlur != null) {
      controllerMap[widget.controller].evaluateJavascript(source: """
          \$('#summernote-2').on('summernote.blur', function() {
            window.flutter_inappwebview.callHandler('onBlur', 'fired');
          });
        """);
    }
    if (c.onBlurCodeview != null) {
      controllerMap[widget.controller].evaluateJavascript(source: """
          \$('#summernote-2').on('summernote.blur.codeview', function() {
            window.flutter_inappwebview.callHandler('onBlurCodeview', 'fired');
          });
        """);
    }
    if (c.onKeyDown != null) {
      controllerMap[widget.controller].evaluateJavascript(source: """
          \$('#summernote-2').on('summernote.keydown', function(_, e) {
            window.flutter_inappwebview.callHandler('onKeyDown', e.keyCode);
          });
        """);
    }
    if (c.onKeyUp != null) {
      controllerMap[widget.controller].evaluateJavascript(source: """
          \$('#summernote-2').on('summernote.keyup', function(_, e) {
            window.flutter_inappwebview.callHandler('onKeyUp', e.keyCode);
          });
        """);
    }
    if (c.onPaste != null) {
      controllerMap[widget.controller].evaluateJavascript(source: """
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
      controllerMap[widget.controller].addJavaScriptHandler(
          handlerName: 'onChange',
          callback: (contents) {
            c.onChange!.call(contents.first.toString());
          });
    }
    if (c.onEnter != null) {
      controllerMap[widget.controller].addJavaScriptHandler(
          handlerName: 'onEnter',
          callback: (_) {
            c.onEnter!.call();
          });
    }
    if (c.onFocus != null) {
      controllerMap[widget.controller].addJavaScriptHandler(
          handlerName: 'onFocus',
          callback: (_) {
            c.onFocus!.call();
          });
    }
    if (c.onBlur != null) {
      controllerMap[widget.controller].addJavaScriptHandler(
          handlerName: 'onBlur',
          callback: (_) {
            c.onBlur!.call();
          });
    }
    if (c.onBlurCodeview != null) {
      controllerMap[widget.controller].addJavaScriptHandler(
          handlerName: 'onBlurCodeview',
          callback: (_) {
            c.onBlurCodeview!.call();
          });
    }
    if (c.onKeyDown != null) {
      controllerMap[widget.controller].addJavaScriptHandler(
          handlerName: 'onKeyDown',
          callback: (keyCode) {
            c.onKeyDown!.call(keyCode.first);
          });
    }
    if (c.onKeyUp != null) {
      controllerMap[widget.controller].addJavaScriptHandler(
          handlerName: 'onKeyUp',
          callback: (keyCode) {
            c.onKeyUp!.call(keyCode.first);
          });
    }
    if (c.onPaste != null) {
      controllerMap[widget.controller].addJavaScriptHandler(
          handlerName: 'onPaste',
          callback: (_) {
            c.onPaste!.call();
          });
    }
  }
}

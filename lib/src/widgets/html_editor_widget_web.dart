export 'dart:html';

import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html_editor_enhanced/html_editor.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:html_editor_enhanced/utils/shims/dart_ui.dart' as ui;

/// The HTML Editor widget itself, for web (uses IFrameElement)
class HtmlEditorWidget extends StatefulWidget {
  HtmlEditorWidget({
    Key? key,
    required this.controller,
    this.callbacks,
    required this.plugins,
    required this.htmlEditorOptions,
    required this.htmlToolbarOptions,
    required this.otherOptions,
    required this.initBC,
  }) : super(key: key);

  final HtmlEditorController controller;
  final Callbacks? callbacks;
  final List<Plugins> plugins;
  final HtmlEditorOptions htmlEditorOptions;
  final HtmlToolbarOptions htmlToolbarOptions;
  final OtherOptions otherOptions;
  final BuildContext initBC;

  _HtmlEditorWidgetWebState createState() => _HtmlEditorWidgetWebState();
}

/// State for the web Html editor widget
///
/// A stateful widget is necessary here, otherwise the IFrameElement will be
/// rebuilt excessively, hurting performance
class _HtmlEditorWidgetWebState extends State<HtmlEditorWidget> {
  /// The view ID for the IFrameElement. Must be unique.
  late String createdViewId;

  /// The actual height of the editor, used to automatically set the height
  late double actualHeight;

  /// A variable used to correct for the height of the bottom toolbar, if visible.
  double toolbarHeightCorrection = 0;

  /// A Future that is observed by the [FutureBuilder]. We don't use a function
  /// as the Future on the [FutureBuilder] because when the widget is rebuilt,
  /// the function may be excessively called, hurting performance.
  Future<bool>? summernoteInit;

  @override
  void initState() {
    /*if (widget.htmlEditorOptions.showBottomToolbar) toolbarHeightCorrection = 40;*/
    actualHeight = widget.otherOptions.height + 85 + toolbarHeightCorrection;
    createdViewId = getRandString(10);
    controllerMap[widget.controller] = createdViewId;
    initSummernote();
    super.initState();
  }

  void initSummernote() async {
    String headString = "";
    String summernoteCallbacks = "callbacks: {";
    int maximumFileSize = 10485760;
    for (Plugins p in widget.plugins) {
      headString = headString + p.getHeadString() + "\n";
      if (p is SummernoteAtMention) {
        summernoteCallbacks = summernoteCallbacks +
            """
            \nsummernoteAtMention: {
              getSuggestions: (value) => {
                const mentions = ${p.getMentionsWeb()};
                return mentions.filter((mention) => {
                  return mention.includes(value);
                });
              },
              onSelect: (value) => {
                window.parent.postMessage(JSON.stringify({"view": "$createdViewId", "type": "toDart: onSelectMention", "value": value}), "*");
              },
            },
          """;
        if (p.onSelect != null) {
          html.window.onMessage.listen((event) {
            var data = json.decode(event.data);
            if (data["type"] != null &&
                data["type"].contains("toDart:") &&
                data["view"] == createdViewId &&
                data["type"].contains("onSelectMention")) {
              p.onSelect!.call(data["value"]);
            }
          });
        }
      }
      if (p is SummernoteFile) {
        maximumFileSize = p.maximumFileSize;
        if (p.onFileUpload != null) {
          summernoteCallbacks = summernoteCallbacks +
              """
                onFileUpload: function(files) {
                  var reader = new FileReader();
                  var base64 = "<an error occurred>";
                  reader.onload = function (_) {
                    base64 = reader.result;
                    var newObject = {
                       'lastModified': files[0].lastModified,
                       'lastModifiedDate': files[0].lastModifiedDate,
                       'name': files[0].name,
                       'size': files[0].size,
                       'type': files[0].type,
                       'base64': base64
                    };
                    window.parent.postMessage(JSON.stringify({"view": "$createdViewId", "type": "toDart: onFileUpload", "lastModified": files[0].lastModified, "lastModifiedDate": files[0].lastModifiedDate, "name": files[0].name, "size": files[0].size, "mimeType": files[0].type, "base64": base64}), "*");
                  };
                  reader.onerror = function (_) {
                    var newObject = {
                       'lastModified': files[0].lastModified,
                       'lastModifiedDate': files[0].lastModifiedDate,
                       'name': files[0].name,
                       'size': files[0].size,
                       'type': files[0].type,
                       'base64': base64
                    };
                    window.parent.postMessage(JSON.stringify({"view": "$createdViewId", "type": "toDart: onFileUpload", "lastModified": files[0].lastModified, "lastModifiedDate": files[0].lastModifiedDate, "name": files[0].name, "size": files[0].size, "mimeType": files[0].type, "base64": base64}), "*");
                  };
                  reader.readAsDataURL(files[0]);
                },
            """;
          html.window.onMessage.listen((event) {
            var data = json.decode(event.data);
            if (data["type"] != null &&
                data["type"].contains("toDart: onFileUpload") &&
                data["view"] == createdViewId) {
              Map<String, dynamic> map = {
                'lastModified': data["lastModified"],
                'lastModifiedDate': data["lastModifiedDate"],
                'name': data["name"],
                'size': data["size"],
                'type': data["mimeType"],
                'base64': data["base64"]
              };
              String jsonStr = json.encode(map);
              FileUpload file = fileUploadFromJson(jsonStr);
              p.onFileUpload!.call(file);
            }
          });
        }
        if (p.onFileLinkInsert != null) {
          summernoteCallbacks = summernoteCallbacks +
              """
                onFileLinkInsert: function(link) {
                  window.parent.postMessage(JSON.stringify({"view": "$createdViewId", "type": "toDart: onFileLinkInsert", "link": link}), "*");
                },
            """;
          html.window.onMessage.listen((event) {
            var data = json.decode(event.data);
            if (data["type"] != null &&
                data["type"].contains("toDart: onFileLinkInsert") &&
                data["view"] == createdViewId) {
              p.onFileLinkInsert!.call(data["link"]);
            }
          });
        }
        if (p.onFileUploadError != null) {
          summernoteCallbacks = summernoteCallbacks +
              """
                onFileUploadError: function(file, error) {
                  if (typeof file === 'string') {
                    window.parent.postMessage(JSON.stringify({"view": "$createdViewId", "type": "toDart: onFileUploadError", "base64": file, "error": error}), "*");
                  } else {
                    window.parent.postMessage(JSON.stringify({"view": "$createdViewId", "type": "toDart: onFileUploadError", "lastModified": file.lastModified, "lastModifiedDate": file.lastModifiedDate, "name": file.name, "size": file.size, "mimeType": file.type, "error": error}), "*");
                  }
                },
            """;
          html.window.onMessage.listen((event) {
            var data = json.decode(event.data);
            if (data["type"] != null &&
                data["type"].contains("toDart: onFileUploadError") &&
                data["view"] == createdViewId) {
              if (data["base64"] != null) {
                p.onFileUploadError!.call(
                    null,
                    data["base64"],
                    data["error"].contains("base64")
                        ? UploadError.jsException
                        : data["error"].contains("unsupported")
                        ? UploadError.unsupportedFile
                        : UploadError.exceededMaxSize);
              } else {
                Map<String, dynamic> map = {
                  'lastModified': data["lastModified"],
                  'lastModifiedDate': data["lastModifiedDate"],
                  'name': data["name"],
                  'size': data["size"],
                  'type': data["mimeType"]
                };
                String jsonStr = json.encode(map);
                FileUpload file = fileUploadFromJson(jsonStr);
                p.onFileUploadError!.call(
                    file,
                    null,
                    data["error"].contains("base64")
                        ? UploadError.jsException
                        : data["error"].contains("unsupported")
                        ? UploadError.unsupportedFile
                        : UploadError.exceededMaxSize);
              }
            }
          });
        }
      }
    }
    if (widget.callbacks != null) {
      if (widget.callbacks!.onImageLinkInsert != null) {
        summernoteCallbacks = summernoteCallbacks +
            """
          onImageLinkInsert: function(url) {
            window.parent.postMessage(JSON.stringify({"view": "$createdViewId", "type": "toDart: onImageLinkInsert", "url": url}), "*");
          },
        """;
      }
      if (widget.callbacks!.onImageUpload != null) {
        summernoteCallbacks = summernoteCallbacks +
            """
          onImageUpload: function(files) {
            var reader = new FileReader();
            var base64 = "<an error occurred>";
            reader.onload = function (_) {
              base64 = reader.result;
              var newObject = {
                 'lastModified': files[0].lastModified,
                 'lastModifiedDate': files[0].lastModifiedDate,
                 'name': files[0].name,
                 'size': files[0].size,
                 'type': files[0].type,
                 'base64': base64
              };
              window.parent.postMessage(JSON.stringify({"view": "$createdViewId", "type": "toDart: onImageUpload", "lastModified": files[0].lastModified, "lastModifiedDate": files[0].lastModifiedDate, "name": files[0].name, "size": files[0].size, "mimeType": files[0].type, "base64": base64}), "*");
            };
            reader.onerror = function (_) {
              var newObject = {
                 'lastModified': files[0].lastModified,
                 'lastModifiedDate': files[0].lastModifiedDate,
                 'name': files[0].name,
                 'size': files[0].size,
                 'type': files[0].type,
                 'base64': base64
              };
              window.parent.postMessage(JSON.stringify({"view": "$createdViewId", "type": "toDart: onImageUpload", "lastModified": files[0].lastModified, "lastModifiedDate": files[0].lastModifiedDate, "name": files[0].name, "size": files[0].size, "mimeType": files[0].type, "base64": base64}), "*");
            };
            reader.readAsDataURL(files[0]);
          },
        """;
      }
      if (widget.callbacks!.onImageUploadError != null) {
        summernoteCallbacks = summernoteCallbacks +
            """
              onImageUploadError: function(file, error) {
                if (typeof file === 'string') {
                  window.parent.postMessage(JSON.stringify({"view": "$createdViewId", "type": "toDart: onImageUploadError", "base64": file, "error": error}), "*");
                } else {
                  window.parent.postMessage(JSON.stringify({"view": "$createdViewId", "type": "toDart: onImageUploadError", "lastModified": file.lastModified, "lastModifiedDate": file.lastModifiedDate, "name": file.name, "size": file.size, "mimeType": file.type, "error": error}), "*");
                }
              },
            """;
      }
    }
    summernoteCallbacks = summernoteCallbacks + "}";
    String darkCSS = "";
    if ((Theme.of(widget.initBC).brightness == Brightness.dark ||
            widget.htmlEditorOptions.darkMode == true) &&
        widget.htmlEditorOptions.darkMode != false) {
      darkCSS =
          "<link href=\"assets/packages/html_editor_enhanced/assets/summernote-lite-dark.css\" rel=\"stylesheet\">";
    }
    String jsCallbacks = "";
    if (widget.callbacks != null)
      jsCallbacks = getJsCallbacks(widget.callbacks!);
    String summernoteScripts = """
      <script type="text/javascript">
        \$(document).ready(function () {
          \$('#summernote-2').summernote({
            placeholder: "${widget.htmlEditorOptions.hint}",
            tabsize: 2,
            height: ${widget.otherOptions.height},
            disableGrammar: false,
            spellCheck: false,
            maximumFileSize: $maximumFileSize,
            $summernoteCallbacks
          });
          
          \$('#summernote-2').on('summernote.change', function(_, contents, \$editable) {
            window.parent.postMessage(JSON.stringify({"view": "$createdViewId", "type": "toDart: onChange", "contents": contents}), "*");
          });
        });
       
        window.parent.addEventListener('message', handleMessage, false);
      
        function handleMessage(e) {
          if (e.data.includes("toIframe:")) {
            var data = JSON.parse(e.data);
            if (data["view"].includes("$createdViewId")) {
              if (data["type"].includes("getText")) {
                var str = \$('#summernote-2').summernote('code');
                window.parent.postMessage(JSON.stringify({"type": "toDart: getText", "text": str}), "*");
              }
              if (data["type"].includes("getHeight")) {
                var height = document.body.scrollHeight;
                window.parent.postMessage(JSON.stringify({"view": "$createdViewId", "type": "toDart: htmlHeight", "height": height}), "*");
              }
              if (data["type"].includes("setText")) {
                \$('#summernote-2').summernote('code', data["text"]);
              }
              if (data["type"].includes("setFullScreen")) {
                \$("#summernote-2").summernote("fullscreen.toggle");
              }
              if (data["type"].includes("setFocus")) {
                \$('#summernote-2').summernote('focus');
              }
              if (data["type"].includes("clear")) {
                \$('#summernote-2').summernote('reset');
              }
              if (data["type"].includes("setHint")) {
                \$(".note-placeholder").html(data["text"]);
              }
              if (data["type"].includes("toggleCodeview")) {
                \$('#summernote-2').summernote('codeview.toggle');
              }
              if (data["type"].includes("disable")) {
                \$('#summernote-2').summernote('disable');
              }
              if (data["type"].includes("enable")) {
                \$('#summernote-2').summernote('enable');
              }
              if (data["type"].includes("undo")) {
                \$('#summernote-2').summernote('undo');
              }
              if (data["type"].includes("redo")) {
                \$('#summernote-2').summernote('redo');
              }
              if (data["type"].includes("insertText")) {
                \$('#summernote-2').summernote('insertText', data["text"]);
              }
              if (data["type"].includes("insertHtml")) {
                \$('#summernote-2').summernote('pasteHTML', data["html"]);
              }
              if (data["type"].includes("insertNetworkImage")) {
                \$('#summernote-2').summernote('insertImage', data["url"], data["filename"]);
              }
              if (data["type"].includes("insertLink")) {
                \$('#summernote-2').summernote('createLink', {
                  text: data["text"],
                  url: data["url"],
                  isNewWindow: data["isNewWindow"]
                });
              }
              if (data["type"].includes("reload")) {
                window.location.reload();
              }
              if (data["type"].includes("addNotification")) {
                if (data["alertType"] === null) {
                  \$('.note-status-output').html(
                    data["html"]
                  );
                } else {
                  \$('.note-status-output').html(
                    '<div class="' + data["alertType"] + '">' +
                      data["html"] +
                    '</div>'
                  );
                }
              }
              if (data["type"].includes("removeNotification")) {
                \$('.note-status-output').empty();
              }
            }
          }
        }
        
        $jsCallbacks
      </script>
    """;
    String filePath =
        'packages/html_editor_enhanced/assets/summernote-no-plugins.html';
    if (widget.htmlEditorOptions.filePath != null) filePath = widget.htmlEditorOptions.filePath!;
    String htmlString = await rootBundle.loadString(filePath);
    htmlString = htmlString
        .replaceFirst("<!--darkCSS-->", darkCSS)
        .replaceFirst("<!--headString-->", headString)
        .replaceFirst("<!--summernoteScripts-->", summernoteScripts)
        .replaceFirst("jquery.min.js",
            "assets/packages/html_editor_enhanced/assets/jquery.min.js")
        .replaceFirst("summernote-lite.min.css",
            "assets/packages/html_editor_enhanced/assets/summernote-lite.min.css")
        .replaceFirst("summernote-lite.min.js",
            "assets/packages/html_editor_enhanced/assets/summernote-lite.min.js");
    if (widget.callbacks != null) addJSListener(widget.callbacks!);
    final html.IFrameElement iframe = html.IFrameElement()
      ..width = MediaQuery.of(widget.initBC).size.width.toString() //'800'
      ..height = widget.htmlEditorOptions.autoAdjustHeight
          ? actualHeight.toString()
          : widget.otherOptions.height.toString()
      ..srcdoc = htmlString
      ..style.border = 'none'
      ..onLoad.listen((event) async {
        if (widget.callbacks != null && widget.callbacks!.onInit != null)
          widget.callbacks!.onInit!.call();
        if (widget.htmlEditorOptions.initialText != null)
          widget.controller.setText(widget.htmlEditorOptions.initialText!);
        Map<String, Object> data = {"type": "toIframe: getHeight"};
        data["view"] = createdViewId;
        final jsonEncoder = JsonEncoder();
        var jsonStr = jsonEncoder.convert(data);
        html.window.postMessage(jsonStr, "*");
        html.window.onMessage.listen((event) {
          var data = json.decode(event.data);
          if (data["type"] != null &&
              data["type"].contains("toDart: onChange") &&
              data["view"] == createdViewId) {
            if (widget.callbacks != null && widget.callbacks!.onChange != null)
              widget.callbacks!.onChange!.call(data["contents"]);
            if (widget.htmlEditorOptions.shouldEnsureVisible &&
                Scrollable.of(context) != null) {
              Scrollable.of(context)!.position.ensureVisible(
                  context.findRenderObject()!,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeIn);
            }
          }
        });
      });
    ui.platformViewRegistry
        .registerViewFactory(createdViewId, (int viewId) => iframe);
    setState(() {
      summernoteInit = Future.value(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.htmlEditorOptions.autoAdjustHeight
          ? actualHeight
          : widget.otherOptions.height,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: FutureBuilder<bool>(
                future: summernoteInit,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return HtmlElementView(
                      viewType: createdViewId,
                    );
                  } else {
                    return Container(
                        height: widget.htmlEditorOptions.autoAdjustHeight
                            ? actualHeight
                            : widget.otherOptions.height);
                  }
                }
              )
            )
          ),
        ],
      ),
    );
  }

  /// Adds the callbacks the user set into JavaScript
  String getJsCallbacks(Callbacks c) {
    String callbacks = "";
    if (c.onBeforeCommand != null) {
      callbacks = callbacks +
          """
          \$('#summernote-2').on('summernote.before.command', function(_, contents, \$editable) {
            window.parent.postMessage(JSON.stringify({"view": "$createdViewId", "type": "toDart: onBeforeCommand", "contents": contents}), "*");
          });\n
        """;
    }
    if (c.onChangeCodeview != null) {
      callbacks = callbacks +
          """
          \$('#summernote-2').on('summernote.change.codeview', function(_, contents, \$editable) {
            window.parent.postMessage(JSON.stringify({"view": "$createdViewId", "type": "toDart: onChangeCodeview", "contents": contents}), "*");
          });\n
        """;
    }
    if (c.onDialogShown != null) {
      callbacks = callbacks +
          """
          \$('#summernote-2').on('summernote.dialog.shown', function() {
            window.parent.postMessage(JSON.stringify({"view": "$createdViewId", "type": "toDart: onDialogShown"}), "*");
          });\n
        """;
    }
    if (c.onEnter != null) {
      callbacks = callbacks +
          """
          \$('#summernote-2').on('summernote.enter', function() {
            window.parent.postMessage(JSON.stringify({"view": "$createdViewId", "type": "toDart: onEnter"}), "*");
          });\n
        """;
    }
    if (c.onFocus != null) {
      callbacks = callbacks +
          """
          \$('#summernote-2').on('summernote.focus', function() {
            window.parent.postMessage(JSON.stringify({"view": "$createdViewId", "type": "toDart: onFocus"}), "*");
          });\n
        """;
    }
    if (c.onBlur != null) {
      callbacks = callbacks +
          """
          \$('#summernote-2').on('summernote.blur', function() {
            window.parent.postMessage(JSON.stringify({"view": "$createdViewId", "type": "toDart: onBlur"}), "*");
          });\n
        """;
    }
    if (c.onBlurCodeview != null) {
      callbacks = callbacks +
          """
          \$('#summernote-2').on('summernote.blur.codeview', function() {
            window.parent.postMessage(JSON.stringify({"view": "$createdViewId", "type": "toDart: onBlurCodeview"}), "*");
          });\n
        """;
    }
    if (c.onKeyDown != null) {
      callbacks = callbacks +
          """
          \$('#summernote-2').on('summernote.keydown', function(_, e) {
            window.parent.postMessage(JSON.stringify({"view": "$createdViewId", "type": "toDart: onKeyDown", "keyCode": e.keyCode}), "*");
          });\n
        """;
    }
    if (c.onKeyUp != null) {
      callbacks = callbacks +
          """
          \$('#summernote-2').on('summernote.keyup', function(_, e) {
            window.parent.postMessage(JSON.stringify({"view": "$createdViewId", "type": "toDart: onKeyUp", "keyCode": e.keyCode}), "*");
          });\n
        """;
    }
    if (c.onMouseDown != null) {
      callbacks = callbacks +
          """
          \$('#summernote-2').on('summernote.mousedown', function(_) {
            window.parent.postMessage(JSON.stringify({"view": "$createdViewId", "type": "toDart: onMouseDown"}), "*");
          });\n
        """;
    }
    if (c.onMouseUp != null) {
      callbacks = callbacks +
          """
          \$('#summernote-2').on('summernote.mouseup', function(_) {
            window.parent.postMessage(JSON.stringify({"view": "$createdViewId", "type": "toDart: onMouseUp"}), "*");
          });\n
        """;
    }
    if (c.onPaste != null) {
      callbacks = callbacks +
          """
          \$('#summernote-2').on('summernote.paste', function(_) {
            window.parent.postMessage(JSON.stringify({"view": "$createdViewId", "type": "toDart: onPaste"}), "*");
          });\n
        """;
    }
    if (c.onScroll != null) {
      callbacks = callbacks +
          """
          \$('#summernote-2').on('summernote.scroll', function(_) {
            window.parent.postMessage(JSON.stringify({"view": "$createdViewId", "type": "toDart: onScroll"}), "*");
          });\n
        """;
    }
    return callbacks;
  }

  /// Adds an event listener to check when a callback is fired
  void addJSListener(Callbacks c) {
    html.window.onMessage.listen((event) {
      var data = json.decode(event.data);
      if (data["type"] != null &&
          data["type"].contains("toDart:") &&
          data["view"] == createdViewId) {
        if (data["type"].contains("htmlHeight") &&
            widget.htmlEditorOptions.autoAdjustHeight) {
          final docHeight = data["height"] ?? actualHeight;
          if ((docHeight != null && docHeight != actualHeight) && mounted) {
            setState(() {
              actualHeight = docHeight + toolbarHeightCorrection;
            });
          }
        }
        if (data["type"].contains("onBeforeCommand")) {
          c.onBeforeCommand!.call(data["contents"]);
        }
        if (data["type"].contains("onChange")) {
          c.onChange!.call(data["contents"]);
        }
        if (data["type"].contains("onChangeCodeview")) {
          c.onChangeCodeview!.call(data["contents"]);
        }
        if (data["type"].contains("onDialogShown")) {
          c.onDialogShown!.call();
        }
        if (data["type"].contains("onEnter")) {
          c.onEnter!.call();
        }
        if (data["type"].contains("onFocus")) {
          c.onFocus!.call();
        }
        if (data["type"].contains("onBlur")) {
          c.onBlur!.call();
        }
        if (data["type"].contains("onBlurCodeview")) {
          c.onBlurCodeview!.call();
        }
        if (data["type"].contains("onImageLinkInsert")) {
          c.onImageLinkInsert!.call(data["url"]);
        }
        if (data["type"].contains("onImageUpload")) {
          Map<String, dynamic> map = {
            'lastModified': data["lastModified"],
            'lastModifiedDate': data["lastModifiedDate"],
            'name': data["name"],
            'size': data["size"],
            'type': data["mimeType"],
            'base64': data["base64"]
          };
          String jsonStr = json.encode(map);
          FileUpload file = fileUploadFromJson(jsonStr);
          c.onImageUpload!.call(file);
        }
        if (data["type"].contains("onImageUploadError")) {
          if (data["base64"] != null) {
            c.onImageUploadError!.call(
                null,
                data["base64"],
                data["error"].contains("base64")
                    ? UploadError.jsException
                    : data["error"].contains("unsupported")
                        ? UploadError.unsupportedFile
                        : UploadError.exceededMaxSize);
          } else {
            Map<String, dynamic> map = {
              'lastModified': data["lastModified"],
              'lastModifiedDate': data["lastModifiedDate"],
              'name': data["name"],
              'size': data["size"],
              'type': data["mimeType"]
            };
            String jsonStr = json.encode(map);
            FileUpload file = fileUploadFromJson(jsonStr);
            c.onImageUploadError!.call(
                file,
                null,
                data["error"].contains("base64")
                    ? UploadError.jsException
                    : data["error"].contains("unsupported")
                        ? UploadError.unsupportedFile
                        : UploadError.exceededMaxSize);
          }
        }
        if (data["type"].contains("onKeyDown")) {
          c.onKeyDown!.call(data["keyCode"]);
        }
        if (data["type"].contains("onKeyUp")) {
          c.onKeyUp!.call(data["keyCode"]);
        }
        if (data["type"].contains("onMouseDown")) {
          c.onMouseDown!.call();
        }
        if (data["type"].contains("onMouseUp")) {
          c.onMouseUp!.call();
        }
        if (data["type"].contains("onPaste")) {
          c.onPaste!.call();
        }
        if (data["type"].contains("onScroll")) {
          c.onScroll!.call();
        }
      }
    });
  }

  /// Generates a random string to be used as the view ID. Technically this
  /// limits the number of editors to a finite number, but nobody will be
  /// embedding enough editors to reach the theoretical limit (yes, this
  /// is a challenge ;-) )
  String getRandString(int len) {
    var random = Random.secure();
    var values = List<int>.generate(len, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }
}

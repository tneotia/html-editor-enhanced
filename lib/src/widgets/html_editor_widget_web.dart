export 'dart:html';

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:html_editor_enhanced/utils/toolbar_icon.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui' as ui;

class HtmlEditorWidget extends StatefulWidget {
  HtmlEditorWidget({
    Key key,
    this.value,
    this.height,
    this.showBottomToolbar,
    this.hint,
    this.callbacks,
    this.toolbar,
    this.darkMode,
    this.initBC,
  }) : super(key: key);

  final String value;
  final double height;
  final bool showBottomToolbar;
  final String hint;
  final UniqueKey webViewKey = UniqueKey();
  final Callbacks callbacks;
  final List<Toolbar> toolbar;
  final bool darkMode;
  final String createdViewId = 'html_editor_web';
  final BuildContext initBC;

  _HtmlEditorWidgetWebState createState() => _HtmlEditorWidgetWebState();
}

class _HtmlEditorWidgetWebState extends State<HtmlEditorWidget> {
  final String createdViewId = 'html_editor_web';
  
  @override
  void initState() {
    super.initState();
    String summernoteToolbar = "[\n";
    for (Toolbar t in widget.toolbar) {
      summernoteToolbar = summernoteToolbar +
          "['${t.getGroupName()}', ${t.getButtons()}],\n";
    }
    summernoteToolbar = summernoteToolbar + "],";
    String darkCSS = "";
    if ((Theme.of(widget.initBC).brightness == Brightness.dark || widget.darkMode == true) && widget.darkMode != false) {
      darkCSS = "<link href=\"assets/packages/html_editor_enhanced/assets/summernote-lite-dark.css\" rel=\"stylesheet\">";
    }
    String jsCallbacks = getJsCallbacks();
    String htmlString = """
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
        <meta name="description" content="Flutter Summernote HTML Editor">
        <meta name="author" content="tneotia">
        <title>Summernote Text Editor HTML</title>
        <script src="assets/packages/html_editor_enhanced/assets/jquery-3.4.1.slim.min.js" type="application/javascript"></script>
        <link href="assets/packages/html_editor_enhanced/assets/summernote-lite.min.css" rel="stylesheet">
        <script src="assets/packages/html_editor_enhanced/assets/summernote-lite.min.js" type="application/javascript"></script>
        $darkCSS
      </head>
      <body>
      <div id="summernote-2"></div>
      <script type="text/javascript">
        \$('#summernote-2').summernote({
          placeholder: "${widget.hint}",
          tabsize: 2,
          height: ${widget.height - 125},
          maxHeight: ${widget.height - 125},
          toolbar: $summernoteToolbar
          disableGrammar: false,
          spellCheck: false
        });
       
        window.parent.addEventListener('message', handleMessage, false);
      
        function handleMessage(e) {
          if (e.data.includes("toIframe:")) {
            var data = JSON.parse(e.data);
            if (data["type"].includes("getText")) {
                var str = \$('#summernote-2').summernote('code');
                window.parent.postMessage(JSON.stringify({"type": "toDart: getText", "text": str}), "*");
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
          }
        }
        
        $jsCallbacks
      </script>
      <style>
        body {
            display: block;
            margin: 0px;
        }
        .note-editor.note-airframe, .note-editor.note-frame {
            border: 0px solid #a9a9a9;
        }
        .note-frame {
            border-radius: 0px;
        }
      </style>
      </body>
      </html>
    """;
    final html.IFrameElement iframe = html.IFrameElement()
      ..width = MediaQuery.of(widget.initBC).size.width.toString() //'800'
      ..height = widget.height.toString()
      ..srcdoc = htmlString
      ..style.border = 'none'
      ..onLoad.listen((event) async {
        if (widget.value != null) {
          HtmlEditor.setText(widget.value);
        }
      });
    addJSListener();
    ui.platformViewRegistry.registerViewFactory(createdViewId, (int viewId) => iframe);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
            child: Directionality(
                textDirection: TextDirection.ltr,
                child: HtmlElementView(
                  viewType: createdViewId,
                )
            )
        ),
        widget.showBottomToolbar ? Divider(height: 0) : Container(height: 0, width: 0),
        widget.showBottomToolbar ? Padding(
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

  String getJsCallbacks() {
    String callbacks = "";
    if (widget.callbacks.onChange != null) {
      callbacks = callbacks + """
          \$('#summernote-2').on('summernote.change', function(_, contents, \$editable) {
            window.parent.postMessage(JSON.stringify({"type": "toDart: onChange", "contents": contents}), "*");
          });\n
        """;
    }
    if (widget.callbacks.onEnter != null) {
      callbacks = callbacks + """
          \$('#summernote-2').on('summernote.enter', function() {
            window.parent.postMessage(JSON.stringify({"type": "toDart: onEnter"}), "*");
          });\n
        """;
    }
    if (widget.callbacks.onFocus != null) {
      callbacks = callbacks + """
          \$('#summernote-2').on('summernote.focus', function() {
            window.parent.postMessage(JSON.stringify({"type": "toDart: onFocus"}), "*");
          });\n
        """;
    }
    if (widget.callbacks.onBlur != null) {
      callbacks = callbacks + """
          \$('#summernote-2').on('summernote.blur', function() {
            window.parent.postMessage(JSON.stringify({"type": "toDart: onBlur"}), "*");
          });\n
        """;
    }
    if (widget.callbacks.onBlurCodeview != null) {
      callbacks = callbacks + """
          \$('#summernote-2').on('summernote.blur.codeview', function() {
            window.parent.postMessage(JSON.stringify({"type": "toDart: onBlurCodeview"}), "*");
          });\n
        """;
    }
    if (widget.callbacks.onKeyDown != null) {
      callbacks = callbacks + """
          \$('#summernote-2').on('summernote.keydown', function(_, e) {
            window.parent.postMessage(JSON.stringify({"type": "toDart: onKeyDown", "keyCode": e.keyCode}), "*");
          });\n
        """;
    }
    if (widget.callbacks.onKeyUp != null) {
      callbacks = callbacks + """
          \$('#summernote-2').on('summernote.keyup', function(_, e) {
            window.parent.postMessage(JSON.stringify({"type": "toDart: onKeyUp", "keyCode": e.keyCode}), "*");
          });\n
        """;
    }
    if (widget.callbacks.onPaste != null) {
      callbacks = callbacks + """
          \$('#summernote-2').on('summernote.paste', function(_) {
            window.parent.postMessage(JSON.stringify({"type": "toDart: onPaste"}), "*");
          });\n
        """;
    }
    return callbacks;
  }

  void addJSListener() {
    html.window.onMessage.listen((event) {
      var data = json.decode(event.data);
      if (data["type"].contains("toDart:")) {
        if (data["type"].contains("onChange")) {
          widget.callbacks.onChange.call(data["contents"]);
        }
        if (data["type"].contains("onEnter")) {
          widget.callbacks.onEnter.call();
        }
        if (data["type"].contains("onFocus")) {
          widget.callbacks.onFocus.call();
        }
        if (data["type"].contains("onBlur")) {
          widget.callbacks.onBlur.call();
        }
        if (data["type"].contains("onBlurCodeview")) {
          widget.callbacks.onBlurCodeview.call();
        }
        if (data["type"].contains("onKeyDown")) {
          widget.callbacks.onKeyDown.call(data["keyCode"]);
        }
        if (data["type"].contains("onKeyUp")) {
          widget.callbacks.onKeyUp.call(data["keyCode"]);
        }
        if (data["type"].contains("onPaste")) {
          widget.callbacks.onPaste.call();
        }
      }
    });
  }
}
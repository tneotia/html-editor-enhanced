export 'dart:html';

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:html_editor_enhanced/utils/utils.dart';
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

  @override
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

  /// A Future that is observed by the [FutureBuilder]. We don't use a function
  /// as the Future on the [FutureBuilder] because when the widget is rebuilt,
  /// the function may be excessively called, hurting performance.
  Future<bool>? summernoteInit;

  /// Helps get the height of the toolbar to accurately adjust the height of
  /// the editor when the keyboard is visible.
  GlobalKey toolbarKey = GlobalKey();

  /// Tracks whether the editor was disabled onInit (to avoid re-disabling on reload)
  bool alreadyDisabled = false;

  @override
  void initState() {
    actualHeight = widget.otherOptions.height;
    createdViewId = getRandString(10);
    widget.controller.viewId = createdViewId;
    initSummernote();
    super.initState();
  }

  void initSummernote() async {
    var headString = '';
    var summernoteCallbacks = '''callbacks: {
        onKeydown: function(e) {
            var chars = \$(".note-editable").text();
            var totalChars = chars.length;
            ${widget.htmlEditorOptions.characterLimit != null ? '''allowedKeys = (
                e.which === 8 ||  /* BACKSPACE */
                e.which === 35 || /* END */
                e.which === 36 || /* HOME */
                e.which === 37 || /* LEFT */
                e.which === 38 || /* UP */
                e.which === 39 || /* RIGHT*/
                e.which === 40 || /* DOWN */
                e.which === 46 || /* DEL*/
                e.ctrlKey === true && e.which === 65 || /* CTRL + A */
                e.ctrlKey === true && e.which === 88 || /* CTRL + X */
                e.ctrlKey === true && e.which === 67 || /* CTRL + C */
                e.ctrlKey === true && e.which === 86 || /* CTRL + V */
                e.ctrlKey === true && e.which === 90    /* CTRL + Z */
            );
            if (!allowedKeys && \$(e.target).text().length >= ${widget.htmlEditorOptions.characterLimit}) {
                e.preventDefault();
            }''' : ''}
            window.parent.postMessage(JSON.stringify({"view": "$createdViewId", "type": "toDart: characterCount", "totalChars": totalChars}), "*");
        },
    ''';
    var maximumFileSize = 10485760;
    for (var p in widget.plugins) {
      headString = headString + p.getHeadString() + '\n';
      if (p is SummernoteAtMention) {
        summernoteCallbacks = summernoteCallbacks +
            '''
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
          ''';
        if (p.onSelect != null) {
          html.window.onMessage.listen((event) {
            var data = json.decode(event.data);
            if (data['type'] != null &&
                data['type'].contains('toDart:') &&
                data['view'] == createdViewId &&
                data['type'].contains('onSelectMention')) {
              p.onSelect!.call(data['value']);
            }
          });
        }
      }
    }
    if (widget.callbacks != null) {
      if (widget.callbacks!.onImageLinkInsert != null) {
        summernoteCallbacks = summernoteCallbacks +
            '''
          onImageLinkInsert: function(url) {
            window.parent.postMessage(JSON.stringify({"view": "$createdViewId", "type": "toDart: onImageLinkInsert", "url": url}), "*");
          },
        ''';
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
    summernoteCallbacks = summernoteCallbacks + '}';
    var darkCSS = '';
    if ((Theme.of(widget.initBC).brightness == Brightness.dark ||
            widget.htmlEditorOptions.darkMode == true) &&
        widget.htmlEditorOptions.darkMode != false) {
      darkCSS =
          '<link href=\"assets/packages/html_editor_enhanced/assets/summernote-lite-dark.css\" rel=\"stylesheet\">';
    }
    var jsCallbacks = '';
    if (widget.callbacks != null) {
      jsCallbacks = getJsCallbacks(widget.callbacks!);
    }
    var userScripts = '';
    if (widget.htmlEditorOptions.webInitialScripts != null) {
      widget.htmlEditorOptions.webInitialScripts!.forEach((element) {
        userScripts = userScripts +
            '''
          if (data["type"].includes("${element.name}")) {
            ${element.script}
          }
        ''' +
            '\n';
      });
    }
    var summernoteScripts = """
      <script type="text/javascript">
        \$(document).ready(function () {
          \$('#summernote-2').summernote({
            placeholder: "${widget.htmlEditorOptions.hint}",
            tabsize: 2,
            height: ${widget.otherOptions.height},
            disableGrammar: false,
            spellCheck: ${widget.htmlEditorOptions.spellCheck},
            maximumFileSize: $maximumFileSize,
            ${widget.htmlEditorOptions.customOptions}
            $summernoteCallbacks
          });
          
          \$('#summernote-2').on('summernote.change', function(_, contents, \$editable) {
            window.parent.postMessage(JSON.stringify({"view": "$createdViewId", "type": "toDart: onChangeContent", "contents": contents}), "*");
          });
        });
       
        window.parent.addEventListener('message', handleMessage, false);
        document.onselectionchange = onSelectionChange;
        console.log('done');
      
        function handleMessage(e) {
          if (e && e.data && e.data.includes("toIframe:")) {
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
              if (data["type"].includes("setInputType")) {
                document.getElementsByClassName('note-editable')[0].setAttribute('inputmode', '${describeEnum(widget.htmlEditorOptions.inputType)}');
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
              if (data["type"].includes("execCommand")) {
                if (data["argument"] === null) {
                  document.execCommand(data["command"], false);
                } else {
                  document.execCommand(data["command"], false, data["argument"]);
                }
              }
              if (data["type"].includes("changeListStyle")) {
                var \$focusNode = \$(window.getSelection().focusNode);
                var \$parentList = \$focusNode.closest("div.note-editable ol, div.note-editable ul");
                \$parentList.css("list-style-type", data["changed"]);
              }
              if (data["type"].includes("changeLineHeight")) {
                \$('#summernote-2').summernote('lineHeight', data["changed"]);
              }
              if (data["type"].includes("changeTextDirection")) {
                var s=document.getSelection();			
                if(s==''){
                    document.execCommand("insertHTML", false, "<p dir='"+data['direction']+"'></p>");
                }else{
                    document.execCommand("insertHTML", false, "<div dir='"+data['direction']+"'>"+ document.getSelection()+"</div>");
                }
              }
              if (data["type"].includes("changeCase")) {
                var selected = \$('#summernote-2').summernote('createRange');
                  if(selected.toString()){
                      var texto;
                      var count = 0;
                      var value = data["case"];
                      console.log(value);
                      var nodes = selected.nodes();
                      for (var i=0; i< nodes.length; ++i) {
                          if (nodes[i].nodeName == "#text") {
                              count++;
                              texto = nodes[i].nodeValue.toLowerCase();
                              nodes[i].nodeValue = texto;
                              if (value == 'upper') {
                                 nodes[i].nodeValue = texto.toUpperCase();
                              }
                              else if (value == 'sentence' && count==1) {
                                 nodes[i].nodeValue = texto.charAt(0).toUpperCase() + texto.slice(1).toLowerCase();
                              } else if (value == 'title') {
                                var sentence = texto.split(" ");
                                for(var j = 0; j< sentence.length; j++){
                                   sentence[j] = sentence[j][0].toUpperCase() + sentence[j].slice(1);
                                }
                                nodes[i].nodeValue = sentence.join(" ");
                              }
                          }
                      }
                  }
              }
              if (data["type"].includes("insertTable")) {
                \$('#summernote-2').summernote('insertTable', data["dimensions"]);
              }
              if (data["type"].includes("getSelectedTextHtml")) {
                var range = window.getSelection().getRangeAt(0);
                var content = range.cloneContents();
                var span = document.createElement('span');
                  
                span.appendChild(content);
                var htmlContent = span.innerHTML;
                
                window.parent.postMessage(JSON.stringify({"type": "toDart: getSelectedText", "text": htmlContent}), "*");
              } else if (data["type"].includes("getSelectedText")) {
                window.parent.postMessage(JSON.stringify({"type": "toDart: getSelectedText", "text": window.getSelection().toString()}), "*");
              }
              $userScripts
            }
          }
        }
        
        function onSelectionChange() {
          let {anchorNode, anchorOffset, focusNode, focusOffset} = document.getSelection();
          var isBold = false;
          var isItalic = false;
          var isUnderline = false;
          var isStrikethrough = false;
          var isSuperscript = false;
          var isSubscript = false;
          var isUL = false;
          var isOL = false;
          var isLeft = false;
          var isRight = false;
          var isCenter = false;
          var isFull = false;
          var parent;
          var fontName;
          var fontSize = 16;
          var foreColor = "000000";
          var backColor = "FFFF00";
          var focusNode2 = \$(window.getSelection().focusNode);
          var parentList = focusNode2.closest("div.note-editable ol, div.note-editable ul");
          var parentListType = parentList.css('list-style-type');
          var lineHeight = \$(focusNode.parentNode).css('line-height');
          var direction = \$(focusNode.parentNode).css('direction');
          if (document.queryCommandState) {
            isBold = document.queryCommandState('bold');
            isItalic = document.queryCommandState('italic');
            isUnderline = document.queryCommandState('underline');
            isStrikethrough = document.queryCommandState('strikeThrough');
            isSuperscript = document.queryCommandState('superscript');
            isSubscript = document.queryCommandState('subscript');
            isUL = document.queryCommandState('insertUnorderedList');
            isOL = document.queryCommandState('insertOrderedList');
            isLeft = document.queryCommandState('justifyLeft');
            isRight = document.queryCommandState('justifyRight');
            isCenter = document.queryCommandState('justifyCenter');
            isFull = document.queryCommandState('justifyFull');
          }
          if (document.queryCommandValue) {
            parent = document.queryCommandValue('formatBlock');
            fontSize = document.queryCommandValue('fontSize');
            foreColor = document.queryCommandValue('foreColor');
            backColor = document.queryCommandValue('hiliteColor');
            fontName = document.queryCommandValue('fontName');
          }
          var message = {
            'view': "$createdViewId", 
            'type': "toDart: updateToolbar",
            'style': parent,
            'fontName': fontName,
            'fontSize': fontSize,
            'font': [isBold, isItalic, isUnderline],
            'miscFont': [isStrikethrough, isSuperscript, isSubscript],
            'color': [foreColor, backColor],
            'paragraph': [isUL, isOL],
            'listStyle': parentListType,
            'align': [isLeft, isCenter, isRight, isFull],
            'lineHeight': lineHeight,
            'direction': direction,
          };
          window.parent.postMessage(JSON.stringify(message), "*");
        }
        
        $jsCallbacks
      </script>
    """;
    var filePath =
        'packages/html_editor_enhanced/assets/summernote-no-plugins.html';
    if (widget.htmlEditorOptions.filePath != null) {
      filePath = widget.htmlEditorOptions.filePath!;
    }
    var htmlString = await rootBundle.loadString(filePath);
    htmlString = htmlString
        .replaceFirst('<!--darkCSS-->', darkCSS)
        .replaceFirst('<!--headString-->', headString)
        .replaceFirst('<!--summernoteScripts-->', summernoteScripts)
        .replaceFirst('"jquery.min.js"',
            '"assets/packages/html_editor_enhanced/assets/jquery.min.js"')
        .replaceFirst('"summernote-lite.min.css"',
            '"assets/packages/html_editor_enhanced/assets/summernote-lite.min.css"')
        .replaceFirst('"summernote-lite.min.js"',
            '"assets/packages/html_editor_enhanced/assets/summernote-lite.min.js"');
    if (widget.callbacks != null) addJSListener(widget.callbacks!);
    final iframe = html.IFrameElement()
      ..width = MediaQuery.of(widget.initBC).size.width.toString() //'800'
      ..height = widget.htmlEditorOptions.autoAdjustHeight
          ? actualHeight.toString()
          : widget.otherOptions.height.toString()
      // ignore: unsafe_html, necessary to load HTML string
      ..srcdoc = htmlString
      ..style.border = 'none'
      ..style.overflow = 'hidden'
      ..onLoad.listen((event) async {
        if (widget.htmlEditorOptions.disabled && !alreadyDisabled) {
          widget.controller.disable();
          alreadyDisabled = true;
        }
        if (widget.callbacks != null && widget.callbacks!.onInit != null) {
          widget.callbacks!.onInit!.call();
        }
        if (widget.htmlEditorOptions.initialText != null) {
          widget.controller.setText(widget.htmlEditorOptions.initialText!);
        }
        var data = <String, Object>{'type': 'toIframe: getHeight'};
        data['view'] = createdViewId;
        var data2 = <String, Object>{'type': 'toIframe: setInputType'};
        data2['view'] = createdViewId;
        final jsonEncoder = JsonEncoder();
        var jsonStr = jsonEncoder.convert(data);
        var jsonStr2 = jsonEncoder.convert(data2);
        html.window.onMessage.listen((event) {
          var data = json.decode(event.data);
          if (data['type'] != null &&
              data['type'].contains('toDart: htmlHeight') &&
              data['view'] == createdViewId &&
              widget.htmlEditorOptions.autoAdjustHeight) {
            final docHeight = data['height'] ?? actualHeight;
            if ((docHeight != null && docHeight != actualHeight) &&
                mounted &&
                docHeight > 0) {
              setState(mounted, this.setState, () {
                actualHeight =
                    docHeight + (toolbarKey.currentContext?.size?.height ?? 0);
              });
            }
          }
          if (data['type'] != null &&
              data['type'].contains('toDart: onChangeContent') &&
              data['view'] == createdViewId) {
            if (widget.callbacks != null &&
                widget.callbacks!.onChangeContent != null) {
              widget.callbacks!.onChangeContent!.call(data['contents']);
            }
            if (widget.htmlEditorOptions.shouldEnsureVisible &&
                Scrollable.of(context) != null) {
              Scrollable.of(context)!.position.ensureVisible(
                  context.findRenderObject()!,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeIn);
            }
          }
          if (data['type'] != null &&
              data['type'].contains('toDart: updateToolbar') &&
              data['view'] == createdViewId) {
            if (widget.controller.toolbar != null) {
              widget.controller.toolbar!.updateToolbar(data);
            }
          }
        });
        html.window.postMessage(jsonStr, '*');
        html.window.postMessage(jsonStr2, '*');
      });
    ui.platformViewRegistry
        .registerViewFactory(createdViewId, (int viewId) => iframe);
    setState(mounted, this.setState, () {
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
          widget.htmlToolbarOptions.toolbarPosition ==
                  ToolbarPosition.aboveEditor
              ? ToolbarWidget(
                  key: toolbarKey,
                  controller: widget.controller,
                  htmlToolbarOptions: widget.htmlToolbarOptions,
                  callbacks: widget.callbacks)
              : Container(height: 0, width: 0),
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
                      }))),
          widget.htmlToolbarOptions.toolbarPosition ==
                  ToolbarPosition.belowEditor
              ? ToolbarWidget(
                  key: toolbarKey,
                  controller: widget.controller,
                  htmlToolbarOptions: widget.htmlToolbarOptions,
                  callbacks: widget.callbacks)
              : Container(height: 0, width: 0),
        ],
      ),
    );
  }

  /// Adds the callbacks the user set into JavaScript
  String getJsCallbacks(Callbacks c) {
    var callbacks = '';
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
      if (data['type'] != null &&
          data['type'].contains('toDart:') &&
          data['view'] == createdViewId) {
        if (data['type'].contains('onBeforeCommand')) {
          c.onBeforeCommand!.call(data['contents']);
        }
        if (data['type'].contains('onChangeContent')) {
          c.onChangeContent!.call(data['contents']);
        }
        if (data['type'].contains('onChangeCodeview')) {
          c.onChangeCodeview!.call(data['contents']);
        }
        if (data['type'].contains('onDialogShown')) {
          c.onDialogShown!.call();
        }
        if (data['type'].contains('onEnter')) {
          c.onEnter!.call();
        }
        if (data['type'].contains('onFocus')) {
          c.onFocus!.call();
        }
        if (data['type'].contains('onBlur')) {
          c.onBlur!.call();
        }
        if (data['type'].contains('onBlurCodeview')) {
          c.onBlurCodeview!.call();
        }
        if (data['type'].contains('onImageLinkInsert')) {
          c.onImageLinkInsert!.call(data['url']);
        }
        if (data['type'].contains('onImageUpload')) {
          var map = <String, dynamic>{
            'lastModified': data['lastModified'],
            'lastModifiedDate': data['lastModifiedDate'],
            'name': data['name'],
            'size': data['size'],
            'type': data['mimeType'],
            'base64': data['base64']
          };
          var jsonStr = json.encode(map);
          var file = fileUploadFromJson(jsonStr);
          c.onImageUpload!.call(file);
        }
        if (data['type'].contains('onImageUploadError')) {
          if (data['base64'] != null) {
            c.onImageUploadError!.call(
                null,
                data['base64'],
                data['error'].contains('base64')
                    ? UploadError.jsException
                    : data['error'].contains('unsupported')
                        ? UploadError.unsupportedFile
                        : UploadError.exceededMaxSize);
          } else {
            var map = <String, dynamic>{
              'lastModified': data['lastModified'],
              'lastModifiedDate': data['lastModifiedDate'],
              'name': data['name'],
              'size': data['size'],
              'type': data['mimeType']
            };
            var jsonStr = json.encode(map);
            var file = fileUploadFromJson(jsonStr);
            c.onImageUploadError!.call(
                file,
                null,
                data['error'].contains('base64')
                    ? UploadError.jsException
                    : data['error'].contains('unsupported')
                        ? UploadError.unsupportedFile
                        : UploadError.exceededMaxSize);
          }
        }
        if (data['type'].contains('onKeyDown')) {
          c.onKeyDown!.call(data['keyCode']);
        }
        if (data['type'].contains('onKeyUp')) {
          c.onKeyUp!.call(data['keyCode']);
        }
        if (data['type'].contains('onMouseDown')) {
          c.onMouseDown!.call();
        }
        if (data['type'].contains('onMouseUp')) {
          c.onMouseUp!.call();
        }
        if (data['type'].contains('onPaste')) {
          c.onPaste!.call();
        }
        if (data['type'].contains('onScroll')) {
          c.onScroll!.call();
        }
        if (data['type'].contains('characterCount')) {
          widget.controller.characterCount = data['totalChars'];
        }
      }
    });
  }
}

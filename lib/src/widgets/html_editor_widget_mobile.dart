import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:html_editor_enhanced/html_editor.dart'
    hide NavigationActionPolicy, UserScript, ContextMenu;
import 'package:html_editor_enhanced/utils/utils.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// The HTML Editor widget itself, for mobile (uses InAppWebView)
class HtmlEditorWidget extends StatefulWidget {
  HtmlEditorWidget({
    Key? key,
    required this.controller,
    this.callbacks,
    this.lang = 'ja',
    required this.plugins,
    required this.htmlEditorOptions,
    required this.htmlToolbarOptions,
    required this.otherOptions,
  }) : super(key: key);

  final HtmlEditorController controller;
  final Callbacks? callbacks;
  final String? lang;
  final List<Plugins> plugins;
  final HtmlEditorOptions htmlEditorOptions;
  final HtmlToolbarOptions htmlToolbarOptions;
  final OtherOptions otherOptions;

  @override
  _HtmlEditorWidgetMobileState createState() => _HtmlEditorWidgetMobileState();
}

/// State for the mobile Html editor widget
///
/// A stateful widget is necessary here to allow the height to dynamically adjust.
class _HtmlEditorWidgetMobileState extends State<HtmlEditorWidget> {
  /// Tracks whether the callbacks were initialized or not to prevent re-initializing them
  bool callbacksInitialized = false;

  /// The height of the document loaded in the editor
  late double docHeight;

  /// The file path to the html code
  late String filePath;

  /// String to use when creating the key for the widget
  late String key;

  /// Stream to transfer the [VisibilityInfo.visibleFraction] to the [onWindowFocus]
  /// function of the webview
  StreamController<double> visibleStream = StreamController<double>.broadcast();

  /// Helps get the height of the toolbar to accurately adjust the height of
  /// the editor when the keyboard is visible.
  GlobalKey toolbarKey = GlobalKey();

  /// Variable to cache the viewable size of the editor to update it in case
  /// the editor is focused much after its visibility changes
  double? cachedVisibleDecimal;

  @override
  void initState() {
    docHeight = widget.otherOptions.height;
    key = getRandString(10);
    if (widget.htmlEditorOptions.filePath != null) {
      filePath = widget.htmlEditorOptions.filePath!;
    } else if (widget.plugins.isEmpty) {
      filePath =
          'packages/html_editor_enhanced/assets/summernote-no-plugins.html';
    } else {
      filePath = 'packages/html_editor_enhanced/assets/summernote.html';
    }
    super.initState();
  }

  @override
  void dispose() {
    visibleStream.close();
    super.dispose();
  }

  /// resets the height of the editor to the original height
  void resetHeight() async {
    if (mounted) {
      this.setState(() {
        docHeight = widget.otherOptions.height;
      });
      await widget.controller.editorController!.evaluateJavascript(
          source:
              "\$('div.fr-box.fr-basic').outerHeight(${widget.otherOptions.height - (toolbarKey.currentContext?.size?.height ?? 0)});");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: VisibilityDetector(
        key: Key(key),
        onVisibilityChanged: (VisibilityInfo info) async {
          if (!visibleStream.isClosed) {
            cachedVisibleDecimal = info.visibleFraction == 1
                ? (info.size.height / widget.otherOptions.height).clamp(0, 1)
                : info.visibleFraction;
            visibleStream.add(info.visibleFraction == 1
                ? (info.size.height / widget.otherOptions.height).clamp(0, 1)
                : info.visibleFraction);
          }
        },
        child: Container(
          clipBehavior: Clip.antiAlias,
          height: docHeight + 10,
          decoration: widget.otherOptions.decoration,
          child: Column(
            children: [
              widget.htmlToolbarOptions.toolbarPosition ==
                      ToolbarPosition.aboveEditor
                  ? ToolbarWidget(
                      key: toolbarKey,
                      controller: widget.controller,
                      htmlToolbarOptions: widget.htmlToolbarOptions,
                      callbacks: widget.callbacks)
                  : Container(height: 0, width: 0),
              Expanded(
                child: InAppWebView(
                  initialFile: filePath,
                  onWebViewCreated: (InAppWebViewController controller) {
                    widget.controller.editorController = controller;
                    controller.addJavaScriptHandler(
                        handlerName: 'FormatSettings',
                        callback: (e) {
                          var json = e[0] as Map<String, dynamic>;
                          if (widget.controller.toolbar != null) {
                            widget.controller.toolbar!.updateToolbar(json);
                          }
                        });
                  },
                  initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        javaScriptEnabled: true,
                        transparentBackground: true,
                        useShouldOverrideUrlLoading: true,
                      ),
                      android: AndroidInAppWebViewOptions(
                        useHybridComposition: widget
                            .htmlEditorOptions.androidUseHybridComposition,
                        loadWithOverviewMode: true,
                      )),
                  initialUserScripts:
                      widget.htmlEditorOptions.mobileInitialScripts
                          as UnmodifiableListView<UserScript>?,
                  contextMenu: widget.htmlEditorOptions.mobileContextMenu
                      as ContextMenu?,
                  gestureRecognizers: {
                    Factory<VerticalDragGestureRecognizer>(
                        () => VerticalDragGestureRecognizer()),
                    Factory<LongPressGestureRecognizer>(() =>
                        LongPressGestureRecognizer(
                            duration: widget
                                .htmlEditorOptions.mobileLongPressDuration)),
                  },
                  shouldOverrideUrlLoading: (controller, action) async {
                    if (!action.request.url.toString().contains(filePath)) {
                      return (await widget.callbacks?.onNavigationRequestMobile
                                  ?.call(action.request.url.toString()))
                              as NavigationActionPolicy? ??
                          NavigationActionPolicy.ALLOW;
                    }
                    return NavigationActionPolicy.ALLOW;
                  },
                  onConsoleMessage: (controller, message) {},
                  onWindowFocus: (controller) async {
                    if (widget.htmlEditorOptions.shouldEnsureVisible &&
                        Scrollable.of(context) != null) {
                      await Scrollable.of(context)!.position.ensureVisible(
                            context.findRenderObject()!,
                          );
                    }
                    if (widget.htmlEditorOptions.adjustHeightForKeyboard &&
                        mounted &&
                        !visibleStream.isClosed) {
                      Future<void> setHeightJS() async {
                        await controller.evaluateJavascript(source: """
                                \$('div.fr-box.fr-basic').outerHeight(${max(docHeight - (toolbarKey.currentContext?.size?.height ?? 0), 30)});
                              """);
                      }

                      /// this is a workaround so jumping between focus on different
                      /// editable elements still resizes the editor
                      if ((cachedVisibleDecimal ?? 0) > 0.1) {
                        this.setState(() {
                          docHeight = widget.otherOptions.height *
                              cachedVisibleDecimal!;
                        });
                        await setHeightJS();
                      }
                      var visibleDecimal = await visibleStream.stream.first;
                      var newHeight = widget.otherOptions.height;
                      if (visibleDecimal > 0.1) {
                        this.setState(() {
                          docHeight = newHeight * visibleDecimal;
                        });
                        //todo add support for traditional summernote controls again?
                        await setHeightJS();
                      }
                    }
                  },
                  onLoadStop:
                      (InAppWebViewController controller, Uri? uri) async {
                    var url = uri.toString();
                    var maximumFileSize = 10485760;
                    if (url.contains(filePath)) {
                      var summernoteToolbar = '[\n';
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
                              window.flutter_inappwebview.callHandler('totalChars', totalChars);
                          },
                      ''';
                      if (widget.plugins.isNotEmpty) {
                        summernoteToolbar = summernoteToolbar + "['plugins', [";
                        for (var p in widget.plugins) {
                          summernoteToolbar = summernoteToolbar +
                              (p.getToolbarString().isNotEmpty
                                  ? "'${p.getToolbarString()}'"
                                  : '') +
                              (p == widget.plugins.last
                                  ? ']]\n'
                                  : p.getToolbarString().isNotEmpty
                                      ? ', '
                                      : '');
                          if (p is SummernoteAtMention) {
                            summernoteCallbacks = summernoteCallbacks +
                                """
                              \nsummernoteAtMention: {
                                getSuggestions: async function(value) {
                                  var result = await window.flutter_inappwebview.callHandler('getSuggestions', value);
                                  var resultList = result.split(',');
                                  return resultList;
                                },
                                onSelect: (value) => {
                                  window.flutter_inappwebview.callHandler('onSelectMention', value);
                                },
                              },
                            """;
                            controller.addJavaScriptHandler(
                                handlerName: 'getSuggestions',
                                callback: (value) {
                                  return p.getSuggestionsMobile!
                                      .call(value.first.toString())
                                      .toString()
                                      .replaceAll('[', '')
                                      .replaceAll(']', '');
                                });
                            if (p.onSelect != null) {
                              controller.addJavaScriptHandler(
                                  handlerName: 'onSelectMention',
                                  callback: (value) {
                                    p.onSelect!.call(value.first.toString());
                                  });
                            }
                          }
                        }
                      }
                      if (widget.callbacks != null) {
                        if (widget.callbacks!.onImageLinkInsert != null) {
                          summernoteCallbacks = summernoteCallbacks +
                              """
                              onImageLinkInsert: function(url) {
                                window.flutter_inappwebview.callHandler('onImageLinkInsert', url);
                              },
                            """;
                        }
                      }
                      summernoteToolbar = summernoteToolbar + '],';
                      summernoteCallbacks = summernoteCallbacks + '}';
                      await controller.evaluateJavascript(source: """
                          const self = this;
                          new FroalaEditor("#edit", {
                              language: 'ja',
                              quickInsertEnabled: false,
                              charCounterCount: false,
                              linkAlwaysBlank: true,
                              pasteDeniedAttrs: ["id", "style"],
                              pasteDeniedTags: ["h1", "h2", "h3", "h4", "header", "body"],
                              linkAutoPrefix: "https://",
                              placeholderText: "${widget.htmlEditorOptions.hint ?? ""}",
                              height: ${widget.otherOptions.height - (toolbarKey.currentContext?.size?.height ?? 0)},
                              attribution: false,
                              spellCheck: false,
                              fileMaxSize: 20 * 1024 * 1024,
                              events: {
                                initialized: function() {
                                  var editor = this;
                                },
                                "paste.after": function () {
                                  var height = document.body.scrollHeight;
                                  window.flutter_inappwebview.callHandler('setHeight', height);
                                  window.flutter_inappwebview.callHandler('onPaste', 'fired');
                                },
                                "paste.afterCleanup": function (clipboard_html) {
                                  // pasteされた内容にURLが含まれる場合はaタグに変換
                                  var content = self
                                    .unescapeHTML(clipboard_html);
                                  return content;
                                },
                                'contentChanged': function () {
                                  // Do something here.
                                  // this is the editor instance.
                                  window.flutter_inappwebview.callHandler('onChangeContent', this.html.get(true));
                                }
                              },
                              ${widget.htmlEditorOptions.customOptions}
                              $summernoteCallbacks
                          });

                          FroalaEditor.RegisterCommand("title", {
                            title: "",
                            icon: "",
                            focus: true,
                            undo: true,
                            refreshAfterCallback: true,
                            callback: function () {
                              let txt = this.html.getSelected();
                              if (
                                this.selection.blocks().length != 0 &&
                                this.selection.blocks()[0].className == "title"
                              ) {
                                this.node.clearAttributes(this.selection.blocks()[0]);
                                return;
                              }

                              if (
                                this.selection.text() === undefined ||
                                this.selection.text() == ""
                              ) {
                                this.html.insert('<div class="title"></div><p></p>');
                                return;
                              }

                              this.html.insert('<div class="title"></div><p>' + txt + "</p>");
                            },
                          });

                          FroalaEditor.RegisterCommand("codeTag", {
                            title: "codeタグ",
                            icon: "code",
                            focus: true,
                            undo: true,
                            callback: function () {
                              if (
                                this.selection.get().focusNode &&
                                this.selection.get().focusNode.tagName == "CODE"
                              ) {
                                const parentNode = this.selection.get().focusNode.parentNode;
                                this.node.clearAttributes(parentNode);
                                this.selection.get().focusNode.remove();
                                return;
                              }

                              const parentNode = this.node.blockParent(this.selection.blocks()[0]);
                              if (
                                (parentNode !== null && parentNode.tagName == "CODE") ||
                                (this.selection.blocks()[0] &&
                                  this.selection.blocks()[0].tagName == "CODE")
                              ) {
                                const parentNode = this.selection.blocks()[0].parentNode;
                                this.node.clearAttributes(parentNode);
                                const contents = this.selection.blocks()[0].childNodes;
                                this.selection.blocks()[0].remove();
                                this.html.insert(
                                  Array.from(contents)
                                    .map((x) => (x.outerHTML ? x.outerHTML : x.textContent))
                                    .join("")
                                );
                                return;
                              }

                              if (
                                this.selection.text() === undefined ||
                                this.selection.text() == ""
                              ) {
                                this.html.insert(
                                  '<div class="fr-inner"><code class="fr-deletable fr-inner"><br></code></div><br>'
                                );
                              } else {
                                let txt = this.html.getSelected();
                                this.html.insert(
                                  '<div class="fr-inner"><code class="fr-deletable">' +
                                    txt +
                                    "</code></div><br>"
                                );
                              }
                            },
                          });

                          FroalaEditor.RegisterCommand("infobox", {
                            title: "囲み枠",
                            focus: true,
                            undo: true,
                            callback: function () {
                              let txt = this.html.getSelected();
                              const parentNode = this.node.blockParent(this.selection.blocks()[0]);
                              if (txt.match(\/<div class="infobox">.*<\\/div>\/) && parentNode == null) {
                                this.node.clearAttributes(this.selection.element());
                                const parentNode = this.node.blockParent(this.selection.element());
                                this.node.clearAttributes(parentNode);
                                return;
                              }
                              if (
                                parentNode != null &&
                                parentNode.outerHTML.match(\/<div class="infobox">.*<\\/div>\/)
                              ) {
                                const superParentNode = parentNode.parentNode;
                                this.node.clearAttributes(parentNode);
                                this.node.clearAttributes(superParentNode);
                                return;
                              }

                              if (
                                this.selection.text() === undefined ||
                                this.selection.text() == ""
                              ) {
                                this.html.insert(
                                  '<div class="fr-inner"><div class="infobox"><p></p></div></div><p></p>'
                                );
                                return;
                              }

                              this.html.insert(
                                '<div class="fr-inner"><div class="infobox">' +
                                  txt +
                                  "</div></div><p></p>"
                              );
                            },
                          });

                          function unescapeHTML(str) {
                            if (typeof str !== "string") return str;
                            var patterns = {
                              "&lt;": "<",
                              "&gt;": ">",
                              "&amp;": "&",
                              "&quot;": '"',
                              "&#x27;": "'",
                              "&#x60;": "`",
                            };

                            return str.replace(/&(lt|gt|amp|quot|#x27|#x60);/g, function (match) {
                              return patterns[match];
                            });
                          };

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
                            var parentTitle = \$(focusNode2.closest(".title"));
                            var parentCode = \$(focusNode2.closest("code"));
                            var parentInfobox = \$(focusNode2.closest(".infobox"));
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
                              'style': parent,
                              'fontName': fontName,
                              'fontSize': fontSize,
                              'font': [isBold, isItalic, isUnderline],
                              'miscFont': [isStrikethrough, isSuperscript, isSubscript],
                              'color': [foreColor, backColor],
                              'paragraph': [isUL, isOL],
                              'align': [isLeft, isCenter, isRight, isFull],
                              'lineHeight': lineHeight,
                              'direction': direction,
                              'parentTitle': parentTitle,
                              'parentCode': parentCode,
                              'parentInfobox': parentInfobox
                            };
                            window.flutter_inappwebview.callHandler('FormatSettings', message);
                          }
                      """);
                      await controller.evaluateJavascript(
                          source:
                              "document.onselectionchange = onSelectionChange; console.log('done');");
                      if ((Theme.of(context).brightness == Brightness.dark ||
                              widget.htmlEditorOptions.darkMode == true) &&
                          widget.htmlEditorOptions.darkMode != false) {
                        //todo fix for iOS (https://github.com/pichillilorenzo/flutter_inappwebview/issues/695)
                        var darkCSS =
                            '<link href=\"${(widget.htmlEditorOptions.filePath != null ? "file:///android_asset/flutter_assets/packages/html_editor_enhanced/assets/" : "") + "summernote-lite-dark.css"}\" rel=\"stylesheet\">';
                        await controller.evaluateJavascript(
                            source: "\$('head').append('$darkCSS');");
                      }
                      //set the text once the editor is loaded
                      if (widget.htmlEditorOptions.initialText != null) {
                        widget.controller
                            .setText(widget.htmlEditorOptions.initialText!);
                      }
                      //adjusts the height of the editor when it is loaded
                      if (widget.htmlEditorOptions.autoAdjustHeight) {
                        controller.addJavaScriptHandler(
                            handlerName: 'setHeight',
                            callback: (height) {
                              if (height.first == 'reset') {
                                resetHeight();
                              } else {
                                setState(mounted, this.setState, () {
                                  docHeight = (double.tryParse(
                                              height.first.toString()) ??
                                          widget.otherOptions.height) +
                                      (toolbarKey
                                              .currentContext?.size?.height ??
                                          0);
                                });
                              }
                            });
                        await controller.evaluateJavascript(
                            source:
                                "var height = document.body.scrollHeight; window.flutter_inappwebview.callHandler('setHeight', height);");
                      }
                      //reset the editor's height if the keyboard disappears at any point
                      if (widget.htmlEditorOptions.adjustHeightForKeyboard) {
                        var keyboardVisibilityController =
                            KeyboardVisibilityController();
                        keyboardVisibilityController.onChange
                            .listen((bool visible) {
                          if (!visible && mounted) {
                            controller.clearFocus();
                            resetHeight();
                          }
                        });
                      }
                      widget.controller.editorController!.addJavaScriptHandler(
                          handlerName: 'totalChars',
                          callback: (keyCode) {
                            widget.controller.characterCount =
                                keyCode.first as int;
                          });
                      //disable editor if necessary
                      if (widget.htmlEditorOptions.disabled &&
                          !callbacksInitialized) {
                        widget.controller.disable();
                      }
                      //initialize callbacks
                      if (widget.callbacks != null && !callbacksInitialized) {
                        addJSCallbacks(widget.callbacks!);
                        addJSHandlers(widget.callbacks!);
                        callbacksInitialized = true;
                      }
                      //call onInit callback
                      if (widget.callbacks != null &&
                          widget.callbacks!.onInit != null) {
                        widget.callbacks!.onInit!.call();
                      }
                      //add onChange handler
                      controller.addJavaScriptHandler(
                          handlerName: 'onChangeContent',
                          callback: (contents) {
                            if (widget.htmlEditorOptions.shouldEnsureVisible &&
                                Scrollable.of(context) != null) {
                              Scrollable.of(context)!.position.ensureVisible(
                                    context.findRenderObject()!,
                                  );
                            }
                            if (widget.callbacks != null &&
                                widget.callbacks!.onChangeContent != null) {
                              widget.callbacks!.onChangeContent!
                                  .call(contents.first.toString());
                            }
                          });
                    }
                  },
                ),
              ),
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
        ),
      ),
    );
  }

  /// adds the callbacks set by the user into the scripts
  void addJSCallbacks(Callbacks c) {
    if (c.onBeforeCommand != null) {
      widget.controller.editorController!.evaluateJavascript(source: """
          \$('#summernote-2').on('summernote.before.command', function(_, contents) {
            window.flutter_inappwebview.callHandler('onBeforeCommand', contents);
          });
        """);
    }
    if (c.onChangeCodeview != null) {
      widget.controller.editorController!.evaluateJavascript(source: """
          \$('#summernote-2').on('summernote.change.codeview', function(_, contents, \$editable) {
            window.flutter_inappwebview.callHandler('onChangeCodeview', contents);
          });
        """);
    }
    if (c.onDialogShown != null) {
      widget.controller.editorController!.evaluateJavascript(source: """
          \$('#summernote-2').on('summernote.dialog.shown', function() {
            window.flutter_inappwebview.callHandler('onDialogShown', 'fired');
          });
        """);
    }
    if (c.onEnter != null) {
      widget.controller.editorController!.evaluateJavascript(source: """
          \$('#summernote-2').on('summernote.enter', function() {
            window.flutter_inappwebview.callHandler('onEnter', 'fired');
          });
        """);
    }
    if (c.onFocus != null) {
      widget.controller.editorController!.evaluateJavascript(source: """
          \$('#summernote-2').on('summernote.focus', function() {
            window.flutter_inappwebview.callHandler('onFocus', 'fired');
          });
        """);
    }
    if (c.onBlur != null) {
      widget.controller.editorController!.evaluateJavascript(source: """
          \$('#summernote-2').on('summernote.blur', function() {
            window.flutter_inappwebview.callHandler('onBlur', 'fired');
          });
        """);
    }
    if (c.onBlurCodeview != null) {
      widget.controller.editorController!.evaluateJavascript(source: """
          \$('#summernote-2').on('summernote.blur.codeview', function() {
            window.flutter_inappwebview.callHandler('onBlurCodeview', 'fired');
          });
        """);
    }
    if (c.onKeyDown != null) {
      widget.controller.editorController!.evaluateJavascript(source: """
          \$('#summernote-2').on('summernote.keydown', function(_, e) {
            window.flutter_inappwebview.callHandler('onKeyDown', e.keyCode);
          });
        """);
    }
    if (c.onKeyUp != null) {
      widget.controller.editorController!.evaluateJavascript(source: """
          \$('#summernote-2').on('summernote.keyup', function(_, e) {
            window.flutter_inappwebview.callHandler('onKeyUp', e.keyCode);
          });
        """);
    }
    if (c.onMouseDown != null) {
      widget.controller.editorController!.evaluateJavascript(source: """
          \$('#summernote-2').on('summernote.mousedown', function(_) {
            window.flutter_inappwebview.callHandler('onMouseDown', 'fired');
          });
        """);
    }
    if (c.onMouseUp != null) {
      widget.controller.editorController!.evaluateJavascript(source: """
          \$('#summernote-2').on('summernote.mouseup', function(_) {
            window.flutter_inappwebview.callHandler('onMouseUp', 'fired');
          });
        """);
    }
    if (c.onPaste != null) {
      widget.controller.editorController!.evaluateJavascript(source: """
          \$('#summernote-2').on('summernote.paste', function(_) {
            window.flutter_inappwebview.callHandler('onPaste', 'fired');
          });
        """);
    }
    if (c.onScroll != null) {
      widget.controller.editorController!.evaluateJavascript(source: """
          \$('#summernote-2').on('summernote.scroll', function(_) {
            window.flutter_inappwebview.callHandler('onScroll', 'fired');
          });
        """);
    }
  }

  /// creates flutter_inappwebview JavaScript Handlers to handle any callbacks the
  /// user has defined
  void addJSHandlers(Callbacks c) {
    if (c.onBeforeCommand != null) {
      widget.controller.editorController!.addJavaScriptHandler(
          handlerName: 'onBeforeCommand',
          callback: (contents) {
            c.onBeforeCommand!.call(contents.first.toString());
          });
    }
    if (c.onDialogShown != null) {
      widget.controller.editorController!.addJavaScriptHandler(
          handlerName: 'onDialogShown',
          callback: (_) {
            c.onDialogShown!.call();
          });
    }
    if (c.onEnter != null) {
      widget.controller.editorController!.addJavaScriptHandler(
          handlerName: 'onEnter',
          callback: (_) {
            c.onEnter!.call();
          });
    }
    if (c.onFocus != null) {
      widget.controller.editorController!.addJavaScriptHandler(
          handlerName: 'onFocus',
          callback: (_) {
            c.onFocus!.call();
          });
    }
    if (c.onBlur != null) {
      widget.controller.editorController!.addJavaScriptHandler(
          handlerName: 'onBlur',
          callback: (_) {
            c.onBlur!.call();
          });
    }
    if (c.onBlurCodeview != null) {
      widget.controller.editorController!.addJavaScriptHandler(
          handlerName: 'onBlurCodeview',
          callback: (_) {
            c.onBlurCodeview!.call();
          });
    }
    if (c.onImageLinkInsert != null) {
      widget.controller.editorController!.addJavaScriptHandler(
          handlerName: 'onImageLinkInsert',
          callback: (url) {
            c.onImageLinkInsert!.call(url.first.toString());
          });
    }
    if (c.onImageUpload != null) {
      widget.controller.editorController!.addJavaScriptHandler(
          handlerName: 'onImageUpload',
          callback: (files) {
            var file = fileUploadFromJson(files.first);
            c.onImageUpload!.call(file);
          });
    }
    if (c.onImageUploadError != null) {
      widget.controller.editorController!.addJavaScriptHandler(
          handlerName: 'onImageUploadError',
          callback: (args) {
            if (!args.first.toString().startsWith('{')) {
              c.onImageUploadError!.call(
                  null,
                  args.first,
                  args.last.contains('base64')
                      ? UploadError.jsException
                      : args.last.contains('unsupported')
                          ? UploadError.unsupportedFile
                          : UploadError.exceededMaxSize);
            } else {
              var file = fileUploadFromJson(args.first.toString());
              c.onImageUploadError!.call(
                  file,
                  null,
                  args.last.contains('base64')
                      ? UploadError.jsException
                      : args.last.contains('unsupported')
                          ? UploadError.unsupportedFile
                          : UploadError.exceededMaxSize);
            }
          });
    }
    if (c.onKeyDown != null) {
      widget.controller.editorController!.addJavaScriptHandler(
          handlerName: 'onKeyDown',
          callback: (keyCode) {
            c.onKeyDown!.call(keyCode.first);
          });
    }
    if (c.onKeyUp != null) {
      widget.controller.editorController!.addJavaScriptHandler(
          handlerName: 'onKeyUp',
          callback: (keyCode) {
            c.onKeyUp!.call(keyCode.first);
          });
    }
    if (c.onMouseDown != null) {
      widget.controller.editorController!.addJavaScriptHandler(
          handlerName: 'onMouseDown',
          callback: (_) {
            c.onMouseDown!.call();
          });
    }
    if (c.onMouseUp != null) {
      widget.controller.editorController!.addJavaScriptHandler(
          handlerName: 'onMouseUp',
          callback: (_) {
            c.onMouseUp!.call();
          });
    }
    if (c.onPaste != null) {
      widget.controller.editorController!.addJavaScriptHandler(
          handlerName: 'onPaste',
          callback: (_) {
            c.onPaste!.call();
          });
    }
    if (c.onScroll != null) {
      widget.controller.editorController!.addJavaScriptHandler(
          handlerName: 'onScroll',
          callback: (_) {
            c.onScroll!.call();
          });
    }
  }
}

library html_editor;

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html_editor_enhanced/pick_image.dart';
import 'package:path/path.dart' as p;

typedef void OnClik();

class HtmlEditor extends StatefulWidget {
  final String value;
  final double height;
  final BoxDecoration decoration;
  final bool useBottomSheet;
  final String widthImage;
  final bool showBottomToolbar;
  final String hint;

  HtmlEditor(
      {Key key,
        this.value,
        this.height = 380,
        this.decoration,
        this.useBottomSheet = true,
        this.widthImage = "100%",
        this.showBottomToolbar = true,
        this.hint})
      : super(key: key);

  @override
  HtmlEditorState createState() => HtmlEditorState();
}

class HtmlEditorState extends State<HtmlEditor> with WidgetsBindingObserver {
  InAppWebViewController controller;
  String text = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: widget.decoration ??
          BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            border: Border.all(color: Color(0xffececec), width: 1),
          ),
      child: Column(
        children: <Widget>[
          Expanded(
            child: InAppWebView(
              key: UniqueKey(),
              initialFile: 'packages/html_editor_enhanced/assets/summernote.html',
              onWebViewCreated: (webviewController) {
                WidgetsBinding.instance.addObserver(this);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  controller = webviewController;
                });
              },
              initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    javaScriptEnabled: true,
                  ),
                  android: AndroidInAppWebViewOptions(
                    useHybridComposition: true,
                  )
              ),
              gestureRecognizers: [
                Factory(
                        () => VerticalDragGestureRecognizer()..onUpdate = (_) {}),
              ].toSet(),
              onConsoleMessage: (controller, message) {
                String isi = message.message;
                if (isi.isEmpty ||
                    isi == "<p></p>" ||
                    isi == "<p><br></p>" ||
                    isi == "<p><br/></p>") {
                  isi = "";
                }
                setState(() {
                  text = isi;
                });
              },
              onLoadStop: (controller, String url) {
                if (widget.hint != null) {
                  setHint(widget.hint);
                } else {
                  setHint("");
                }

                setFullContainer();
                if (widget.value != null) {
                  setText(widget.value);
                }
              },
            ),
          ),
          widget.showBottomToolbar
              ? Divider()
              : Container(height: 0, width: 0),
          widget.showBottomToolbar
              ? Padding(
            padding: const EdgeInsets.only(
                left: 4.0, right: 4, bottom: 8, top: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                widgetIcon(Icons.image, "Image", onKlik: () {
                  widget.useBottomSheet
                      ? bottomSheetPickImage(context)
                      : dialogPickImage(context);
                }),
                widgetIcon(Icons.content_copy, "Copy", onKlik: () async {
                  String data = await getText();
                  Clipboard.setData(new ClipboardData(text: data));
                }),
                widgetIcon(Icons.content_paste, "Paste",
                    onKlik: () async {
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
                      String txt =
                          "\$('.note-editable').append( '" + txtIsi + "');";
                      controller.evaluateJavascript(source: txt);
                    }),
              ],
            ),
          )
              : Container(
            height: 1,
          )
        ],
      ),
    );
  }

  Future<String> getText() async {
    await controller.evaluateJavascript(source:
    "console.log(document.getElementsByClassName('note-editable')[0].innerHTML);");
    return text;
  }

  setText(String v) async {
    String txtIsi = v
        .replaceAll("'", '\\"')
        .replaceAll('"', '\\"')
        .replaceAll("[", "\\[")
        .replaceAll("]", "\\]")
        .replaceAll("\n", "<br/>")
        .replaceAll("\n\n", "<br/>")
        .replaceAll("\r", " ")
        .replaceAll('\r\n', " ");
    String txt =
        "document.getElementsByClassName('note-editable')[0].innerHTML = '" +
            txtIsi +
            "';";
    controller.evaluateJavascript(source: txt);
  }

  setFullContainer() {
    controller.evaluateJavascript(source:
    '\$("#summernote").summernote("fullscreen.toggle");');
  }

  setFocus() {
    controller.evaluateJavascript(source: "\$('#summernote').summernote('focus');");
  }

  setEmpty() {
    controller.evaluateJavascript(source: "\$('#summernote').summernote('reset');");
  }

  setHint(String text) {
    String hint = '\$(".note-placeholder").html("$text");';
    controller.evaluateJavascript(source: hint);
  }

  Widget widgetIcon(IconData icon, String title, {OnClik onKlik}) {
    return InkWell(
      onTap: () {
        onKlik();
      },
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            color: Colors.black38,
            size: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            ),
          )
        ],
      ),
    );
  }

  dialogPickImage(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            content: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              padding: const EdgeInsets.all(12),
              height: 120,
              child: PickImage(
                  color: Colors.black45,
                  callbackFile: (file) async {
                    String filename = p.basename(file.path);
                    List<int> imageBytes = await file.readAsBytes();
                    String base64Image =
                        "<img width=\"${widget.widthImage}\" src=\"data:image/png;base64, "
                        "${base64Encode(imageBytes)}\" data-filename=\"$filename\">";

                    String txt =
                        "\$('.note-editable').append( '" + base64Image + "');";
                    controller.evaluateJavascript(source: txt);
                  }),
            ),
          );
        });
  }

  bottomSheetPickImage(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(builder: (BuildContext context, setStatex) {
            return SingleChildScrollView(
                child: Container(
                  height: 140,
                  width: double.infinity,
                  child: PickImage(callbackFile: (file) async {
                    String filename = p.basename(file.path);
                    List<int> imageBytes = await file.readAsBytes();
                    String base64Image = "<img width=\"${widget.widthImage}\" "
                        "src=\"data:image/png;base64, "
                        "${base64Encode(imageBytes)}\" data-filename=\"$filename\">";
                    String txt =
                        "\$('.note-editable').append( '" + base64Image + "');";
                    controller.evaluateJavascript(source: txt);
                  }),
                ));
          });
        });
  }
}

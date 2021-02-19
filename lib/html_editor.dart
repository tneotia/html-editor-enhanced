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
InAppWebViewController controller;
String text = "";

class HtmlEditor extends StatelessWidget with WidgetsBindingObserver {
  final String value;
  final double height;
  final BoxDecoration decoration;
  final bool useBottomSheet;
  final String widthImage;
  final bool showBottomToolbar;
  final String hint;
  final UniqueKey webViewKey = UniqueKey();

  HtmlEditor({Key key,
        this.value,
        this.height = 380,
        this.decoration,
        this.useBottomSheet = true,
        this.widthImage = "100%",
        this.showBottomToolbar = true,
        this.hint}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: decoration ??
          BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            border: Border.all(color: Color(0xffececec), width: 1),
          ),
      child: Column(
        children: <Widget>[
          Expanded(
            child: InAppWebView(
              initialFile: 'packages/html_editor_enhanced/assets/summernote.html',
              onWebViewCreated: (webViewController) {
                WidgetsBinding.instance.addObserver(this);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  controller = webViewController;
                });
              },
              initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    javaScriptEnabled: true,
                  ),
                  //todo flutter_inappwebview 5.0.0
                  /*android: AndroidInAppWebViewOptions(
                    useHybridComposition: true,
                  )*/
              ),
              gestureRecognizers: {
                Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer())
              },
              onConsoleMessage: (controller, message) {
                String isi = message.message;
                if (isi.isEmpty ||
                    isi == "<p></p>" ||
                    isi == "<p><br></p>" ||
                    isi == "<p><br/></p>") {
                  isi = "";
                }
                text = isi;
              },
              onLoadStop: (controller, String url) {
                if (hint != null) {
                  setHint(hint);
                } else {
                  setHint("");
                }

                setFullContainer();
                if (value != null) {
                  setText(value);
                }
              },
            ),
          ),
          showBottomToolbar
              ? Divider()
              : Container(height: 0, width: 0),
          showBottomToolbar
              ? Padding(
            padding: const EdgeInsets.only(
                left: 4.0, right: 4, bottom: 8, top: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                widgetIcon(Icons.image, "Image", onKlik: () {
                  useBottomSheet
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

  static Future<String> getText() async {
    await controller.evaluateJavascript(source:
    "console.log(document.getElementsByClassName('note-editable')[0].innerHTML);");
    return text;
  }

  static void setText(String v) {
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

  static void setFullContainer() {
    controller.evaluateJavascript(source:
    '\$("#summernote").summernote("fullscreen.toggle");');
  }

  static void setFocus() {
    controller.evaluateJavascript(source: "\$('#summernote').summernote('focus');");
  }

  static void setEmpty() {
    controller.evaluateJavascript(source: "\$('#summernote').summernote('reset');");
  }

  static void setHint(String text) {
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
                        "<img width=\"$widthImage\" src=\"data:image/png;base64, "
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
                    String base64Image = "<img width=\"$widthImage\" "
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
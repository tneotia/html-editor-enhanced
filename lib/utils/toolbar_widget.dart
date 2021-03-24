import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class ToolbarWidget extends StatelessWidget {
  ToolbarWidget({Key? key, required this.controller}) : super(key: key);

  final HtmlEditorController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, bottom: 8, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          toolbarIcon(context, Icons.content_copy, "Copy", onTap: () async {
            String? data = await controller.getText();
            Clipboard.setData(new ClipboardData(text: data));
          }),
          toolbarIcon(context, Icons.content_paste, "Paste", onTap: () async {
            ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
            if (data != null) {
              String text = data.text!;
              controller.insertHtml(text);
            }
          }),
        ],
      ),
    );
  }
}

/// Widget for the toolbar icon
Widget toolbarIcon(BuildContext context, IconData icon, String title,
    {required Function() onTap}) {
  return InkWell(
    onTap: onTap,
    child: Row(
      children: <Widget>[
        Icon(
          icon,
          color: Theme.of(context).iconTheme.color,
          size: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        )
      ],
    ),
  );
}
